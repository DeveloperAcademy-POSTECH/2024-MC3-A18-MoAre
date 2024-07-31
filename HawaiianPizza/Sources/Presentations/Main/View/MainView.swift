//
//  MainView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

struct MainView: View {
  @StateObject private var viewModel = MainViewModel()
  @EnvironmentObject var coordinator: Coordinator
          
  @State private var showTimePicker = false
  @State private var selectedTime = (hour: 00, minute: 00)
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("루틴 설정")
          .font(.title)
          .bold()
        
        Spacer()
      }
      .padding(.top, 27)
      .padding(.bottom, 24)
      
      Button(action: {
        // MARK: - DatePicker : View 수정 예정
        self.showTimePicker.toggle()
      }, label: {
        HStack {
          RoundedRectangle(cornerRadius: 20)
            .fill(Color(UIColor.systemGray4))
            .frame(height: 130)
            .overlay(
              Text("\(String(format: "%02d", selectedTime.hour))")
                .font(.system(size: 120, weight: .light))
                .foregroundStyle(.black)
            )
          
          VStack {
            Text(":")
              .font(.system(size: 120, weight: .light))
              .foregroundStyle(.black)
              .padding(.bottom)
          }
          .frame(height: 130)
          
          RoundedRectangle(cornerRadius: 20)
            .fill(Color(UIColor.systemGray4))
            .frame(height: 130)
            .overlay(
              Text("\(String(format: "%02d", selectedTime.minute))")
                .font(.system(size: 120, weight: .light))
                .foregroundStyle(.black)
            )
        }
      })
      .buttonStyle(PlainButtonStyle())
      .sheet(isPresented: $showTimePicker) {
        TimePickerView(selectedTime: $selectedTime, showTimePicker: $showTimePicker)
          .presentationDetents([.fraction(0.4)])
          .presentationCornerRadius(20)
      }
      
      HStack {
        HStack {
          Text("루틴 설정")
            .font(.title)
            .bold()
          
          Spacer()
        }
        
        Button(action: {
          
        }, label: {
          Image(systemName: "plus")
            .resizable()
            .frame(width: 25, height: 25)
            .bold()
            .foregroundStyle(.black)
        })
      }
      .padding(.top, 32)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(viewModel.items) { item in
            MainRowView(item: item)
              .padding(.trailing, 3)
            
            
            Spacer()
               
        }
    }
    .padding(.horizontal, 16)
    .navigationDestination(for: ViewDestination.self){ destination in
                coordinator.setView(destination: destination)
            }
        
    Spacer()
        
  }
  
  private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }
}

#Preview {
    MainView()
}
