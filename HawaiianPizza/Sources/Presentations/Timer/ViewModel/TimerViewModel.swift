//
//  TimerViewModel.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/31/24.
//
import SwiftUI
import ActivityKit
import UIKit
import Combine
import CoreData

class TimerViewModel: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var progress: CGFloat = 1.0
    @StateObject private var ttsManager = TextToSpeechManager()
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var currentTaskIndex: Int = 0
    var totalSkipTime: TimeInterval = 0
    var activity: Activity<DynamicAttributes>?
    var tasks: [Tasks] = []

    init() {
        loadTasks()
    }
    func loadTasks() {
           let routineID = UUID(uuidString: "YOUR_ROUTINE_UUID_STRING")!
           if let routine = CoreDataManager.shared.fetchRoutine(by: routineID) {
               tasks = CoreDataManager.shared.fetchAllTasks(for: routine)
           }
       }


    func startTask() {
            guard currentTaskIndex < tasks.count else { return }
            let currentTask = tasks[currentTaskIndex]
            remainingTime = TimeInterval(currentTask.taskTime)
            ttsManager.speak(text: "이번 루틴은 \(currentTask.taskName)입니다")
            progress = 1.0
            startTimer()
            startLiveActivity(iconName: currentTask.taskIcon)
        }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                let taskTime = self.tasks[self.currentTaskIndex].taskTime
                self.progress = CGFloat(self.remainingTime) / CGFloat(taskTime)
                
                // 알람 체크
                if self.remainingTime == 300 {
                    self.ttsManager.speak(text: "루틴 종료까지 5분 남았습니다.")
                    HapticHelper.triggerHapticFeedback()
                } else if self.remainingTime == 60 {
                    self.ttsManager.speak(text: "루틴 종료까지 1분 남았습니다.")
                    HapticHelper.triggerHapticFeedback()
                }

                self.updateLiveActivity(iconName: self.tasks[self.currentTaskIndex].taskIcon)
            } else {
                self.nextTask()
            }
        }
        registerBackgroundTask()
    }

    func nextTask() {
            if currentTaskIndex < tasks.count - 1 {
                totalSkipTime += TimeInterval(tasks[currentTaskIndex].taskSkipTime)
                currentTaskIndex += 1
                let currentTask = tasks[currentTaskIndex]
                remainingTime = TimeInterval(currentTask.taskTime)
                progress = 1.0
                startTimer()
                updateLiveActivity(iconName: currentTask.taskIcon)
            } else {
                timer?.invalidate()
                remainingTime = 0
                progress = 0.0
                endLiveActivity()
            }
        }

        func getTask(at index: Int) -> Tasks? {
            guard index >= 0 && index < tasks.count else { return nil }
            return tasks[index]
        }

    private func startLiveActivity(iconName: String) {
        let attributes = DynamicAttributes(name: "Sample Task")
        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))

        do {
            activity = try Activity<DynamicAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }
    }

    private func updateLiveActivity(iconName: String) {
        guard let activity = activity else { return }

        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))

        Task {
            await activity.update(content)
        }
    }

    private func endLiveActivity() {
        guard let activity = activity else { return }

        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: "iconName")
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))

        Task {
            await activity.end(content, dismissalPolicy: .immediate)
        }
    }

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyBackgroundTask") {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }

    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            appDidEnterBackground()
        case .active, .inactive:
            appWillEnterForeground()
        @unknown default:
            break
        }
    }

    private func appDidEnterBackground() {
        registerBackgroundTask()
    }

    private func appWillEnterForeground() {
        endBackgroundTask()
    }
}
