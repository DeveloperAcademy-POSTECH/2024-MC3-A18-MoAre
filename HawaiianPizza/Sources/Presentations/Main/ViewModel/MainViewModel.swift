//
//  MainViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
  @Published var items: [RoutineItem] = []
  
  @Published var selectedRoutine: RoutineItem.ID?
  
  var localNotificationManager: LocalNotificationManager
  
  init(localNotificationManager: LocalNotificationManager) {
    self.localNotificationManager = localNotificationManager
    self.items = [
      RoutineItem(title: "Daily Routine", time: (0, 1), chart: [
        TaskItem(task: "일어나기", type: .one, ratio: 28),
        TaskItem(task: "샤워하기", type: .two, ratio: 57),
        TaskItem(task: "스킨케어", type: .three, ratio: 14),
        TaskItem(task: "옷 입기", type: .one, ratio: 5)
      ]),
      RoutineItem(title: "Special Routine", time: (2, 40), chart: [
        TaskItem(task: "샤워하기", type: .one, ratio: 50),
        TaskItem(task: "스킨케어", type: .two, ratio: 20),
        TaskItem(task: "메이크업", type: .three, ratio: 70),
        TaskItem(task: "옷 입기", type: .one, ratio: 10)
      ])
    ]
  }
  
  func toggleRoutineSelection(for selectedTime: (hour: Int, minute: Int), routineID: RoutineItem.ID) {
    if selectedRoutine == routineID {
      // 같은 루틴을 다시 눌렀을 경우 모든 알림을 제거하고 선택을 해제
      localNotificationManager.removeAllPendingNotifications()
      selectedRoutine = nil
    } else {
      // 다른 루틴을 선택할 경우 기존 알림을 제거하고 새 알림 설정
      localNotificationManager.removeAllPendingNotifications()
      selectedRoutine = routineID
      scheduleRoutineNotification(for: selectedTime)
    }
  }
  
  func scheduleRoutineNotification(for selectedTime: (hour: Int, minute: Int)) {
    
    guard let selectedRoutineID = selectedRoutine,
          let routine = items.first(where: { $0.id == selectedRoutineID }) else { return }
    
    let selectedTotalMinutes = selectedTime.hour * 60 + selectedTime.minute
    let routineDurationMinutes = routine.time.hour * 60 + routine.time.minute
    let totalMinutes = selectedTotalMinutes - routineDurationMinutes
    // 음수일 경우 전날 시간으로 변환
    let adjustedMinutes = (totalMinutes + 1440) % 1440
    
    let hour = adjustedMinutes / 60
    let minute = adjustedMinutes % 60
    
    // 현재 날짜에 계산된 시간 적용
    let now = Date()
    var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    components.hour = hour
    components.minute = minute
    
    // 날짜를 반드시 다음날로 설정
    if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) {
      components.day = Calendar.current.component(.day, from: tomorrow)
      components.month = Calendar.current.component(.month, from: tomorrow)
      components.year = Calendar.current.component(.year, from: tomorrow)
    }
    
    if let routineStartDate = Calendar.current.date(from: components) {
      localNotificationManager.scheduleNotifications(
        startingAt: routineStartDate,
        interval: 3,
        count: 10
      )
    }
  }
}
