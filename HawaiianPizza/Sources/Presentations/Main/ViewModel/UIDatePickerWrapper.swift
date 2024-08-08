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
  @Binding var selectedTime: Date
  
  class Coordinator: NSObject {
    var parent: UIDatePickerWrapper
    
    init(parent: UIDatePickerWrapper) {
      self.parent = parent
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
      parent.selectedTime = sender.date
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
    uiView.date = selectedTime
  }
}
