//
//  UIDatePickerWrapper.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import SwiftUI
import UIKit

// MARK: - DatePicker에서 선택한 시간을 변환
struct UIDatePickerWrapper: UIViewRepresentable {
  @Binding var selectedTime: (hour: Int, minute: Int)
  
  class Coordinator: NSObject {
    var parent: UIDatePickerWrapper
    
    init(parent: UIDatePickerWrapper) {
      self.parent = parent
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour, .minute], from: sender.date)
      if let hour = components.hour, let minute = components.minute {
        parent.selectedTime = (hour, minute)
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIView(context: Context) -> UIDatePicker {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .time
    datePicker.minuteInterval = 5
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
    return datePicker
  }
  
  func updateUIView(_ uiView: UIDatePicker, context: Context) {
    var components = DateComponents()
    components.hour = selectedTime.hour
    components.minute = selectedTime.minute
    let calendar = Calendar.current
    if let date = calendar.date(from: components) {
      uiView.date = date
    }
  }
}
