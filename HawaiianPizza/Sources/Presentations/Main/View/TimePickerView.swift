//
//  TimePickerView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import SwiftUI

struct TimePickerView: View {
  @Binding var selectedTime: (hour: Int, minute: Int)
  @Binding var showTimePicker: Bool
  
  var body: some View {
    VStack {
      UIDatePickerWrapper(selectedTime: $selectedTime)
        .frame(height: 200)
      
      Button(action: {
        self.showTimePicker = false
      }, label: {
        RoundedRectangle(cornerRadius: 10)
          .frame(height: 50)
          .foregroundStyle(Color(UIColor.systemGray))
          .overlay(
            Text("선택")
              .font(.title2)
              .foregroundStyle(.black)
              .bold()
          )
      })
    }
    .padding()
  }
  
//  func setNotification() -> Void {
//    let startDate = Calendar.current.date(bySettingHour: selectedTime.hour, minute: selectedTime.minute, second: 0, of: Date()) ?? Date()
//    let interval: TimeInterval = 3
//    let count = 10
//    
//    let manager = LocalNotificationManager()
//    manager.requestPermission()
//    manager.addNotification(title: "오늘의 루틴")
//    manager.scheduleNotifications(startingAt: startDate, interval: interval, count: count)
//  }
}
