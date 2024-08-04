//
//  MainView.swift
//  MC3_Test
//
//  Created by 유지수 on 7/29/24.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var coordinator: Coordinator
  @StateObject private var viewModel = MainViewModel(localNotificationManager: LocalNotificationManager())
  
  @State private var showTimePicker = false
  @State private var selectedTime = (hour: 00, minute: 00)
  private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }
  @State private var showActionSheet = false
  @State private var routineToDelete: Routine? = nil
  
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      VStack(spacing: 0) {
        
        NavigationLink(destination: TimerView()) {
          EmptyView()
        }
        
        GeometryReader { geometry in
          ZStack {
            Rectangle()
              .fill(Color(red: 0.21, green: 0.22, blue: 0.23))
              .frame(width: geometry.size.width, height: geometry.size.width * 1)
              .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
              HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                  Text("Moare")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color(red: 1, green: 0.39, blue: 0.29))
                  Text("moring assistant")
                    .foregroundStyle(Color(red: 0.92, green: 0.93, blue: 0.91))
                }
                Spacer()
              }
              .padding(.horizontal, 34)
              
              Spacer()
              
              HStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                  Text("외출 시간")
                    .font(.system(size: 48))
                    .bold()
                    .foregroundStyle(Color(red: 0.92, green: 0.93, blue: 0.91))
                    .padding(.bottom, 12)
                  Button(action: {
                    self.showTimePicker.toggle()
                  }, label: {
                    RoundedRectangle(cornerRadius: 24)
                      .fill(Color(red: 0.92, green: 0.93, blue: 0.91))
                      .frame(width: 208, height: 85)
                      .overlay(
                        Text("\(String(format: "%02d", selectedTime.hour)):\(String(format: "%02d", selectedTime.minute))")
                          .font(.system(size: 64))
                          .bold()
                          .foregroundStyle(Color(red: 0.21, green: 0.22, blue: 0.23))
                      )
                  })
                  .buttonStyle(PlainButtonStyle())
                  .sheet(isPresented: $showTimePicker) {
                    TimePickerView(
                      selectedTime: $selectedTime,
                      showTimePicker: $showTimePicker
                    )
                    .presentationDetents([.fraction(0.4)])
                    .presentationCornerRadius(20)
                  }
                }
              }
              .padding(.horizontal, 16)
              
              if let routineStartTime = viewModel.routineStartTime(for: selectedTime) {
                HStack(spacing: 0) {
                  Text("루틴 시작 시간")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.6, green: 0.62, blue: 0.64))
                    .padding(.trailing, 8)
                  
                  Text("\(String(format: "%02d", routineStartTime.hour))시 \(String(format: "%02d", routineStartTime.minute))분")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.92, green: 0.93, blue: 0.91))
                }
                .padding(.top, 16)
              } else {
                HStack(spacing: 0) {
                  Text("루틴 시작 시간")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.6, green: 0.62, blue: 0.64))
                    .padding(.trailing, 8)
                  
                  Text("--시 --분")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.92, green: 0.93, blue: 0.91))
                }
                .padding(.top, 16)
              }
              
              Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
          }
        }
        
        HStack(spacing: 0) {
          Text("루틴 항목")
            .font(.system(size: 24))
            .bold()
          
          Spacer()
          
          Button(action: {
            coordinator.push(destination: .routineSetting)
          }, label: {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundStyle(.black)
          })
        }
        .padding(.horizontal, 16)
        
        if viewModel.items.isEmpty {
          Rectangle()
            .foregroundStyle(.clear)
            .overlay(
              Text("루틴을 추가해 주세요")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color(red: 0.6, green: 0.62, blue: 0.64))
            )
        } else {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
              ForEach(viewModel.items) { item in
                MainItemView(
                  viewModel: viewModel,
                  item: item,
                  isSelected: viewModel.selectedRoutine == item.id,
                  onSelect: {
                      viewModel.toggleRoutineSelection(for: selectedTime, routineID: item.id ?? UUID())
                  },
                  seeDetail: {
                    coordinator.push(destination: .routineSetting)
                  }, 
                  onDelete: {
                    showDeleteActionSheet(for: item)
                  }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .cornerRadiusWithBorder(
                  radius: 16,
                  borderColor: Color(red: 1, green: 0.39, blue: 0.29),
                  lineWidth: viewModel.selectedRoutine == item.id ? 2 : 0
                )
                .padding(.trailing, 8)
              }
            }
          }
          .padding(.top, 32)
          .padding(.leading, 16)
          .confirmationDialog("delete", isPresented: $showActionSheet) {
            Button("루틴 삭제", role: .destructive) {
              // MARK: - 이안 선생님!!!! 여기서 삭제하시면 돼요!!!!
              print("루틴이 삭제되었습니다.")
            }
            Button("cancel", role: .cancel) {
              print("취소되었습니다.")
            }
          }
          
        }
        Spacer()
      }
      .onAppear {
          viewModel.fetchRoutine()
      }
      .navigationDestination(for: ViewDestination.self){ destination in
        coordinator.setView(destination: destination)
      }
    }
  }
  
  private func showDeleteActionSheet(for item: Routine) {
    routineToDelete = item
    showActionSheet = true
  }
}

#Preview {
  MainView()
    .environmentObject(Coordinator())
}
