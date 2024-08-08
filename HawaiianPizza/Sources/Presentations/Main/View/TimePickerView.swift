//
//  TimePickerView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import SwiftUI

struct TimePickerView: View {
  @Binding var selectedTime: Date
  @Binding var showTimePicker: Bool
  
  var body: some View {
    VStack {
      UIDatePickerWrapper(selectedTime: $selectedTime)
        .frame(height: 200)
      
      Button(action: {
        self.showTimePicker = false
        HapticHelper.triggerImpactHaptic(style: .medium)
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
}
