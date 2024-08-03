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

class TimerViewModel: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var progress: CGFloat = 1.0
    @StateObject private var ttsManager = TextToSpeechManager()
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var currentTaskIndex: Int = 0
    var totalSkipTime: TimeInterval = 0
    var activity: Activity<DynamicAttributes>?

    let dummytasks = [
        DummyTask(taskTime: 60, taskSkipTime: 10, taskName: "물 마시기", iconName: "tshirt"),
        DummyTask(taskTime: 40, taskSkipTime: 15, taskName: "영양제 먹기", iconName: "tshirt.fill"),
        DummyTask(taskTime: 50, taskSkipTime: 20, taskName: "가방 챙기기", iconName: "tshirt"),
        DummyTask(taskTime: 60, taskSkipTime: 15, taskName: "씻기", iconName: "tshirt.fill"),
        DummyTask(taskTime: 70, taskSkipTime: 20, taskName: "옷 입기", iconName: "tshirt")
    ]

    init() {
        // 초기에는 라이브 액티비티를 시작하지 않습니다.
    }

    func startTask() {
        remainingTime = dummytasks[currentTaskIndex].taskTime
        ttsManager.speak(text:"이번 루틴은" + dummytasks[currentTaskIndex].taskName + "입니다")
        progress = 1.0
        startTimer()
        startLiveActivity(iconName: dummytasks[currentTaskIndex].iconName)
    }

    func startTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                    let taskTime = self.dummytasks[self.currentTaskIndex].taskTime
                    self.progress = CGFloat(self.remainingTime) / CGFloat(taskTime)
                    
                    // 알람 체크
                    if self.remainingTime == 300 {
                        self.ttsManager.speak(text: "루틴 종료까지 5분 남았습니다.")
                        HapticHelper.triggerHapticFeedback()
                    } else if self.remainingTime == 60 {
                        self.ttsManager.speak(text: "루틴 종료까지 1분 남았습니다.")
                        HapticHelper.triggerHapticFeedback()
                    }

                    self.updateLiveActivity(iconName: self.dummytasks[self.currentTaskIndex].iconName)
                } else {
                    self.nextTask()
                }
            }
            registerBackgroundTask()
        }

    func nextTask() {
        if currentTaskIndex < dummytasks.count - 1 {
            totalSkipTime += dummytasks[currentTaskIndex].taskSkipTime
            currentTaskIndex += 1
            remainingTime = dummytasks[currentTaskIndex].taskTime
            progress = 1.0
            startTimer()
            updateLiveActivity(iconName: dummytasks[currentTaskIndex].iconName)
        } else {
            timer?.invalidate()
            remainingTime = 0
            progress = 0.0
            endLiveActivity()
        }
    }

    func getTask(at index: Int) -> DummyTask? {
        guard index >= 0 && index < dummytasks.count else { return nil }
        return dummytasks[index]
    }

    private func startLiveActivity(iconName: String) {
        let attributes = DynamicAttributes(name: "Sample Task")
        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)

        do {
            activity = try Activity<DynamicAttributes>.request(
                attributes: attributes,
                contentState: state)
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }
    }

    private func updateLiveActivity(iconName: String) {
        guard let activity = activity else { return }

        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)
        Task {
            await activity.update(using: state)
        }
    }

    private func endLiveActivity() {
        guard let activity = activity else { return }

        Task {
            await activity.end(dismissalPolicy: .immediate)
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
