//
//  MainItemVIew.swift
//  HawaiianPizza
//
//  Created by 유지수 on 8/3/24.
//

import SwiftUI

struct MainItemView: View {
  let item: RoutineItem
  let isSelected: Bool
  let onSelect: () -> Void
  
  var totalDuration: Int {
    item.tasks.map { $0.taskTime }.reduce(0, +)
  }
  
  var routineTime: (hour: Int, minute: Int) {
    timeFromMinutes(item.routineTime)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("\(item.routineTitle)")
          .font(.title3)
          .fontWeight(.semibold)
          .foregroundStyle(isSelected ? Color.black : Color(red: 0.6, green: 0.62, blue: 0.64))

        Spacer()
        
        Text("\(routineTime.hour)H \(routineTime.minute)M")
          .font(.title3)
          .bold()
          .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
      }
      .padding(.top, 12)
      .padding(.bottom, 10)
      .padding(.horizontal, 16)
      
      Divider()
        .background(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
        .padding(.bottom, 16)
      
      VStack(spacing: 0) {
        ForEach(item.tasks.prefix(6).indices, id: \.self) { i in
          let widthRatio = CGFloat(item.tasks[i].taskTime) / CGFloat(totalDuration)
          MainRowView(title: item.tasks[i].taskName, duration: item.tasks[i].taskTime, widthRatio: widthRatio, isSelected: isSelected)
            .padding(.bottom, 8)
        }
      }
      .padding(.horizontal, 20)
      
      Spacer()
      
      Button(action: {
        onSelect()
      }, label: {
        Rectangle()
          .frame(height: 52)
          .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
          .overlay(
            Text(isSelected ? "선택 완료" : "선택하기")
              .font(.title3)
              .fontWeight(.heavy)
              .foregroundStyle(Color.white)
          )
      })
    }
    .frame(width: 361, height: 331)
    .background(
      isSelected ? Color(red: 1, green: 0.88, blue: 0.87) : Color(red: 0.92, green: 0.93, blue: 0.91))
  }
  
  private func timeFromMinutes(_ totalMinutes: Int) -> (hour: Int, minute: Int) {
    let hour = totalMinutes / 60
    let minute = totalMinutes % 60
    return (hour, minute)
  }
}
