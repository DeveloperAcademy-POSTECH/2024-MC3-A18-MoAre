//
//  MainViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
  @Published var items: [Routine] = []
  @Published var selectedRoutine: RoutineItem.ID? {
    didSet {
      selectedRoutineID = selectedRoutine?.uuidString ?? ""
    }
  }
  @Published var deleteRoutine: Routine?
  @Published var selectedTime: Date = Date()
  @Published var startTime: Time?
  @AppStorage("selectedRoutine") var selectedRoutineID: String = ""
  
  var localNotificationManager: LocalNotificationManager
  
  init(localNotificationManager: LocalNotificationManager) {
    self.localNotificationManager = localNotificationManager
    fetchRoutine()
    
    if let storedID = UUID(uuidString: selectedRoutineID) {
      selectedRoutine = storedID
    }
  }
  
  func fetchRoutine() {
    items = CoreDataManager.shared.fetchAllRoutines()
  }
  
  func deleteRoutine(routine: Routine) {
    CoreDataManager.shared.deleteRoutine(routine)
    items.removeAll { $0.id == routine.id }
  }
  
  func createTime(startTime: Date) {
    CoreDataManager.shared.createTime(startTime: startTime)
  }
  
  func fetchTime() {
    selectedTime = CoreDataManager.shared.fetchTime()?.startTime ?? Date()
  }
  
  func updateTime(time: Time, selectedTime: Date) {
    CoreDataManager.shared.updateTime(time: time, startTime: selectedTime)
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
      
      if isTimeSaved(for: selectedTime) {
        if let time = CoreDataManager.shared.fetchTime() {
          updateTime(time: time, selectedTime: selectedTimeAsDate(selectedTime))
        }
      } else {
        createTime(startTime: selectedTimeAsDate(selectedTime))
      }
    }
  }
  
  private func selectedTimeAsDate(_ selectedTime: (hour: Int, minute: Int)) -> Date {
    var components = DateComponents()
    components.hour = selectedTime.hour
    components.minute = selectedTime.minute
    return Calendar.current.date(from: components) ?? Date()
  }
  
  private func isTimeSaved(for selectedTime: (hour: Int, minute: Int)) -> Bool {
    return CoreDataManager.shared.fetchTime() != nil
  }
  
  func scheduleRoutineNotification(for selectedTime: (hour: Int, minute: Int)) {
    
    guard let selectedRoutineID = selectedRoutine,
          let routine = items.first(where: { $0.id == selectedRoutineID }) else { return }
    
    let selectedTotalMinutes = selectedTime.hour * 60 + selectedTime.minute
    let totalMinutes = selectedTotalMinutes - Int(routine.routineTime)
    // 음수일 경우 전날 시간으로 변환
    let adjustedMinutes = (totalMinutes + 1440) % 1440
    
    let hour = adjustedMinutes / 60
    let minute = adjustedMinutes % 60
    
    // 현재 날짜에 계산된 시간 적용
    let now = Date()
    var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    components.hour = hour
    components.minute = minute
    
    //    // 날짜를 반드시 다음날로 설정
    //    if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) {
    //      components.day = Calendar.current.component(.day, from: tomorrow)
    //      components.month = Calendar.current.component(.month, from: tomorrow)
    //      components.year = Calendar.current.component(.year, from: tomorrow)
    //    }
    
    if let routineStartDate = Calendar.current.date(from: components) {
      let userInfo: [AnyHashable: Any] = ["routineID": selectedRoutineID.uuidString]
      localNotificationManager.scheduleNotifications(
        startingAt: routineStartDate,
        interval: 3,
        count: 10,
        userInfo: userInfo
      )
    }
  }
  
  func routineStartTime(for selectedTime: (hour: Int, minute: Int)) -> (hour: Int, minute: Int)? {
    guard let selectedID = selectedRoutine,
          let routine = items.first(where: { $0.id == selectedID }) else { return nil }
    
    let selectedTotalMinutes = selectedTime.hour * 60 + selectedTime.minute
    let totalMinutes = selectedTotalMinutes - Int(routine.routineTime)
    let adjustedMinutes = (totalMinutes + 1440) % 1440
    return (hour: adjustedMinutes / 60, minute: adjustedMinutes % 60)
  }
  
  func formattedTime(from totalMinutes: Int) -> String {
    let time = timeFromMinutes(totalMinutes)
    return "\(time.hour)H \(time.minute)M"
  }
  
  private func timeFromMinutes(_ totalMinutes: Int) -> (hour: Int, minute: Int) {
    let hour = totalMinutes / 60
    let minute = totalMinutes % 60
    return (hour, minute)
  }
  
  var selectedFormattedTime: (hour: Int, minute: Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: selectedTime)
    return (components.hour ?? 0, components.minute ?? 0)
  }
  
  
}
