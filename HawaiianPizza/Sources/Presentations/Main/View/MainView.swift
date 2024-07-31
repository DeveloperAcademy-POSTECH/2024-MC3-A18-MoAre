//
//  MainView.swift
//  MC3_Test
//
//  Created by 유지수 on 7/29/24.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var coordinator: Coordinator
  @StateObject private var viewModel = MainViewModel()
    
  @State private var showTimePicker = false
  @State private var selectedTime = (hour: 00, minute: 00)
  private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
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
                        coordinator.push(destination: .routineSetting)
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
                        }
                    }
                }
                .padding(.top, 19)
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: ViewDestination.self){ destination in
                coordinator.setView(destination: destination)
            }
            
            Spacer()
        }
    }
}

#Preview {
  MainView()
}
