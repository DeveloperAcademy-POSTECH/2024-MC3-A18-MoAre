//
//  MainItemVIew.swift
//  HawaiianPizza
//
//  Created by 유지수 on 8/3/24.
//

import SwiftUI

struct MainItemView: View {
  @EnvironmentObject var coordinator: Coordinator
  @ObservedObject var viewModel: MainViewModel
    
  let item: Routine
  let isSelected: Bool
  let onSelect: () -> Void
  let seeDetail: () -> Void
  let onDelete: () -> Void
  
  var totalDuration: Int {
      item.tasksArray.map { Int($0.taskTime) }.reduce(0, +)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
          Text(item.routineTitle ?? "루틴명이 없습니다")
          .font(.title3)
          .fontWeight(.semibold)
          .foregroundStyle(isSelected ? Color.black : Color(red: 0.6, green: 0.62, blue: 0.64))
          .padding(.trailing, 16)
          
          Text("\(viewModel.formattedTime(from: Int(item.routineTime)))")
              .font(.title3)
              .bold()
              .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
        
        Spacer()
        
        Button(action: {
          onDelete()
        }, label: {
          Text("삭제하기")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
        })
      }
      .padding(.top, 12)
      .padding(.bottom, 10)
      .padding(.horizontal, 16)
      
      Divider()
        .background(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
      
      ZStack(alignment: .top) {
        VStack(spacing: 0) {
          ForEach(item.tasksArray.prefix(6).indices, id: \.self) { i in
            let widthRatio = CGFloat(item.tasksArray[i].taskTime) / CGFloat(totalDuration)
              MainRowView(title: item.tasksArray[i].taskName, duration: Int(item.tasksArray[i].taskTime), widthRatio: widthRatio, isSelected: isSelected)
              .padding(.bottom, 8)
          }
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        
        VStack(spacing: 0) {
          Spacer()
            HStack {
                Spacer()
          Button(action: {
            seeDetail()
          }, label: {
              HStack(spacing: 0) {
                  Button {
                      coordinator.push(destination: .routineDetail, routine: item)
                  } label: {
                      Text("더보기")
                          .font(.system(size: 12))
                          .fontWeight(.semibold)
                          .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
                          .padding(.trailing, 8)
                      Image(systemName: "chevron.forward")
                          .resizable()
                          .frame(width: 6, height: 13)
                          .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
                  }
              }
          })
          }
          .padding(.top, 8)
          .padding(.trailing, 16)
        }
      }
      
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
}
