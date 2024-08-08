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
    @Published var routineTitle: String = ""
    @Published var tasks: [Tasks] = []
    @Published var isCompleted = false
    
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var currentTaskIndex: Int = 0
    var totalSkipTime: TimeInterval = 0
    var activity: Activity<DynamicAttributes>?
    var routine: Routine?
    var isTimerRunning = false
    var isActivityRunning = false
    var currentTask: Tasks?
    
    @ObservedObject private var ttsManager = TextToSpeechManager()
    
    static let shared = TimerViewModel()
    
    private init() {}
    
    func loadRoutine(with routineID: String) {
        print("루틴 로드 시작: \(routineID)")
        guard let uuid = UUID(uuidString: routineID) else {
            print("UUID 변환 실패")
            return
        }
        self.routine = CoreDataManager.shared.fetchRoutine(by: uuid)
        if let routine = self.routine {
            DispatchQueue.main.async {
                self.routineTitle = routine.routineTitle ?? "루틴명이 없습니다"
                self.tasks = (routine.tasks?.array as? [Tasks]) ?? []
                print("루틴 로드 완료: \(routine)")
                self.startTask()
            }
        } else {
            print("루틴 로드 실패")
        }
    }
    
    func startTask() {
        guard currentTaskIndex < tasks.count else {
            print("태스크 인덱스 범위 초과")
            return
        }
      
        let currentTask = tasks[currentTaskIndex]
        remainingTime = TimeInterval(currentTask.taskTime * 60)
        print("현재 태스크 시작: \(String(describing: currentTask.taskName)), 시간: \(remainingTime)")
        let taskName = currentTask.taskName ?? "새 루틴"
        ttsManager.speak(text: "이번 루틴은 \(taskName)입니다")
        progress = 1.0
        startTimer()
        startLiveActivity(iconName: currentTask.taskIcon ?? "")
    }
    
    func startTimer() {
        guard !isTimerRunning, let currentTask = currentTask else {
            print("현재 태스크가 설정되지 않았거나 타이머가 이미 실행 중입니다.")
            return
        }
        ttsManager.speak(text: "이번 루틴은 \(String(describing: currentTask.taskName))입니다")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        isTimerRunning = true
        registerBackgroundTask()
    }
    
    func updateTimer() {
        guard remainingTime > 0 else {
            nextTask()
            return
        }
        remainingTime -= 1
        progress = CGFloat(remainingTime) / CGFloat(tasks[currentTaskIndex].taskTime * 60)
        
        switch remainingTime {
        case 300, 60:
            let message = remainingTime == 300 ? "루틴 종료까지 5분 남았습니다." : "루틴 종료까지 1분 남았습니다."
            ttsManager.speak(text: message)
            HapticHelper.triggerHapticFeedback()
        default:
            break
        }
        
        updateLiveActivity(iconName: tasks[currentTaskIndex].taskIcon ?? "")
        print("남은 시간: \(remainingTime), 진행도: \(progress)")
    }
    
    func stopTimer() {
        timer?.invalidate()
        isTimerRunning = false
        endLiveActivity()
    }
    
    func nextTask() {
        if isTimerRunning {
            stopTimer()
        }

        guard currentTaskIndex < tasks.count else {
            print("태스크 인덱스 범위 초과")
            return
        }

        let currentTask = tasks[currentTaskIndex]
        currentTask.taskSkipTime = Int32(TimeInterval(Double(currentTask.taskTime) * 60.0 - remainingTime))
        print("현재 태스크: \(currentTask.taskName ?? "No Name"), 스킵 시간: \(currentTask.taskSkipTime)")

        totalSkipTime += TimeInterval(currentTask.taskSkipTime)

        if currentTaskIndex < tasks.count - 1 {
            currentTaskIndex += 1
            startTask()
        } else {
            completeRoutine()
        }
    }

    private func completeRoutine() {
        stopTimer()
        remainingTime = 0
        progress = 0.0
        print("모든 태스크 완료")
        saveTotalSkipTime()
        DispatchQueue.main.async {
            self.isCompleted = true
        }
    }
    
    private func startLiveActivity(iconName: String) {
        endLiveActivity()
        
        print("라이브 액티비티 시작 시도")
        let attributes = DynamicAttributes(name: "Sample Task")
        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))
        
        do {
            activity = try Activity<DynamicAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            isActivityRunning = true
            print("라이브 액티비티 시작됨")
        } catch {
            print("라이브 액티비티 시작 에러: \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity(iconName: String) {
        guard let activity = activity else {
            print("라이브 액티비티가 실행 중이지 않습니다.")
            startLiveActivity(iconName: iconName)
            return
        }
        
        print("라이브 액티비티 업데이트 시도")
        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: iconName)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))
        
        Task {
            await activity.update(content)
            print("라이브 액티비티 업데이트됨")
        }
    }
    
    func endLiveActivity() {
        guard let activity = activity else {
            print("종료할 라이브 액티비티가 없습니다.")
            return
        }
        
        print("라이브 액티비티 종료 시도")
        let state = DynamicAttributes.ContentState(remainingTime: remainingTime, iconName: "iconName")
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(3600))
        
        Task {
            await activity.end(content, dismissalPolicy: .immediate)
            isActivityRunning = false
            print("라이브 액티비티 종료됨")
        }
    }
    
    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyBackgroundTask") {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
            print("백그라운드 작업 종료됨")
        }
    }
    
    func handleScenePhaseChange(_ newPhase: ScenePhase) {
        if newPhase == .background {
            stopTimer()
        } else if newPhase == .active {
            startTimer()
        }
    }
    
    func saveTotalSkipTime() {
        guard let routine = routine else { return }
        routine.totalSkipTime = Int32(totalSkipTime)
        CoreDataManager.shared.saveContext()
        listTaskSkipTimes()
    }
    func listTaskSkipTimes() {
            tasks.forEach { task in
                print("Task: \(task.taskName ?? "No Name"), Skip Time: \(task.taskSkipTime)")
            }
        }
}
