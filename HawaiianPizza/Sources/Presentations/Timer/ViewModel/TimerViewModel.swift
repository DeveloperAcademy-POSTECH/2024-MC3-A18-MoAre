//
//  TimerViewModel.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/31/24.
//
import SwiftUI
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
    var currentTaskIndex: Int = 0
    var totalSkipTime: TimeInterval = 0
    var routine: Routine?
    var isTimerRunning = false
    var currentTask: Tasks?
    
    private var ttsManager = TextToSpeechManager()
    
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
        currentTask = tasks[currentTaskIndex]
        remainingTime = TimeInterval(currentTask!.taskTime * 60)
        print("현재 태스크 시작: \(String(describing: currentTask!.taskName)), 시간: \(remainingTime)")
        
        progress = 1.0
        startTimer()
    }
    
    func startTimer() {
        guard !isTimerRunning, let currentTask = currentTask else {
            print("현재 태스크가 설정되지 않았거나 타이머가 이미 실행 중입니다.")
            return
        }
        if let taskName = currentTask.taskName {
            ttsManager.speak(text: "이번 루틴은 \(taskName)입니다")
        } else {
            ttsManager.speak(text: "이번 루틴은 이름이 없습니다")
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        isTimerRunning = true
    }
    
    func updateTimer() {
        guard remainingTime > 0 else {
            print("타이머가 0이 되어 다음 태스크로 이동합니다.")
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
        print("남은 시간: \(remainingTime), 진행도: \(progress)")
    }
    
    func stopTimer() {
        timer?.invalidate()
        isTimerRunning = false
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

    func completeRoutine() {
        stopTimer()
        remainingTime = 0
        progress = 0.0
        print("모든 태스크 완료")
        saveTotalSkipTime()
        DispatchQueue.main.async {
            self.isCompleted = true
        }
    }
    
    func saveTotalSkipTime() {
        guard let routine = routine else { return }
        routine.totalSkipTime = Int32(totalSkipTime)
        CoreDataManager.shared.saveContext()
    }
    
    func listTaskSkipTimes() {
        tasks.forEach { task in
            print("Task: \(task.taskName ?? "No Name"), Skip Time: \(task.taskSkipTime)")
        }
    }
}
