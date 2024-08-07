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
    
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var currentTaskIndex: Int = 0
    var totalSkipTime: TimeInterval = 0
    var activity: Activity<DynamicAttributes>?
    var routine: Routine?
    var isTimerRunning = false
    var isActivityRunning = false
    
    @ObservedObject private var ttsManager = TextToSpeechManager()
    
    static let shared = TimerViewModel() // 싱글톤 인스턴스
    
    private init() {}
    
    func loadRoutine(with routineID: String) {
        print("루틴 로드 시작: \(routineID)")
        guard let uuid = UUID(uuidString: routineID) else {
            print("UUID 변환 실패")
            return
        }
        self.routine = CoreDataManager.shared.fetchRoutine(by: uuid)
        if let routine = self.routine {
            self.routineTitle = routine.routineTitle ?? "루틴명이 없습니다"
            if let orderedTasks = routine.tasks?.array as? [Tasks] {
                self.tasks = orderedTasks
            } else {
                self.tasks = []
            }
            print("루틴 로드 완료: \(routine)")
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
        ttsManager.speak(text: "이번 루틴은 \(String(describing: currentTask.taskName))입니다")
        progress = 1.0
        startTimer()
        startLiveActivity(iconName: currentTask.taskIcon ?? "")
    }
    
    func startTimer() {
        if isTimerRunning { return } // 이미 타이머가 실행 중이면 실행하지 않음
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                let taskTime = self.tasks[self.currentTaskIndex].taskTime
                self.progress = CGFloat(self.remainingTime) / CGFloat(taskTime * 60)
                
                // 알람 체크
                if self.remainingTime == 300 {
                    self.ttsManager.speak(text: "루틴 종료까지 5분 남았습니다.")
                    HapticHelper.triggerHapticFeedback()
                } else if self.remainingTime == 60 {
                    self.ttsManager.speak(text: "루틴 종료까지 1분 남았습니다.")
                    HapticHelper.triggerHapticFeedback()
                }
                
                self.updateLiveActivity(iconName: self.tasks[self.currentTaskIndex].taskIcon ?? "")
                print("남은 시간: \(self.remainingTime), 진행도: \(self.progress)")
            } else {
                self.nextTask()
            }
        }
        isTimerRunning = true
        registerBackgroundTask()
    }
    
    func stopTimer() {
        timer?.invalidate()
        isTimerRunning = false
        endLiveActivity()
    }
    
    func nextTask() {
        stopTimer() // 다음 태스크로 넘어갈 때 타이머를 멈춤
        
        if currentTaskIndex < tasks.count - 1 {
            totalSkipTime += TimeInterval(tasks[currentTaskIndex].taskSkipTime)
            currentTaskIndex += 1
            let currentTask = tasks[currentTaskIndex]
            remainingTime = TimeInterval(currentTask.taskTime * 60)
            progress = 1.0
            startTimer()
            startLiveActivity(iconName: currentTask.taskIcon ?? "") // 새로운 라이브 액티비티 시작
            print("다음 태스크로 이동: \(String(describing: currentTask.taskName))")
        } else {
            stopTimer() // 모든 태스크가 완료되면 타이머를 멈춤
            remainingTime = 0
            progress = 0.0
            print("모든 태스크 완료")
        }
    }
    
    private func startLiveActivity(iconName: String) {
        endLiveActivity() // 기존 라이브 액티비티 종료
        
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
            startLiveActivity(iconName: iconName) // 라이브 액티비티가 없으면 새로 시작
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
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
            print("백그라운드 작업 종료됨")
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
        print("앱이 백그라운드로 이동")
    }
    
    private func appWillEnterForeground() {
        endBackgroundTask()
        print("앱이 포그라운드로 이동")
    }
}
