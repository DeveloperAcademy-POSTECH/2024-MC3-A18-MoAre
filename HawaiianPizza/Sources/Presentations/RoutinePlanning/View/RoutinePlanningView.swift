//
//  RoutinePlanningView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/25/24.
//

import SwiftUI

// MARK: - 부리 : 잔디 심기 전체 뷰
struct RoutinePlanningView: View {
  @EnvironmentObject var coordinator: Coordinator
    
  @State private var totalMinutes: Int = 0
  @State var routineTitle: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("루틴 설정")
          .font(.title)
          .bold()
          .padding(.leading, 16)
        
        Spacer()
      }
      .padding(.top, 27)
      
      TextField("루틴명", text: $routineTitle)
        .font(.system(.title3).bold())
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
      // padding 수정 가능
        .padding(.top, 16)
        .padding(.horizontal, 20)
      
      HStack {
        Text("루틴 총 시간")
          .font(.system(.headline).bold())
          .foregroundStyle(.gray)
          .padding(.top, 22)
          .padding(.leading, 24)
        
        Spacer()
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .frame(height: 106)
          .foregroundStyle(Color(UIColor.systemGray4))
          .padding(.top, 17)
          .padding(.horizontal, 20)
        
        HStack(alignment: .lastTextBaseline,spacing: 0) {
          Text("\(calculateTime().0)")
            .font(.system(size: 64))
            .padding(.trailing, 2)
          Text("hr")
            .font(.largeTitle)
            .foregroundStyle(Color(UIColor.systemGray))
            .padding(.trailing, 8)
          Text("\(calculateTime().1)")
            .font(.system(size: 64))
            .padding(.trailing, 2)
          Text("min")
            .font(.largeTitle)
            .foregroundStyle(Color(UIColor.systemGray))
        }
        .padding(.top, 15)
      }
      
      VStack(spacing: 0) {
        // 앞에서 입력한 태스크 수에 따라 변화
        ForEach(0..<5) { rowIndex in
          PlanningRowView(rowIndex: rowIndex, totalMinutes: $totalMinutes)
        }
      }
      .padding(.top, 40)
      
      Spacer()
      
      Button(action: {
          coordinator.push(destination: .main)
      }, label: {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .frame(height: 60)
            .foregroundStyle(Color(UIColor.systemGray2))
            .padding(.horizontal, 20)
          
          Text("루틴 완성")
            .foregroundStyle(.black)
            .font(.title2)
            .bold()
            .padding()
        }
      })
    }
  }
  
  func calculateTime() -> (Int, Int) {
    if totalMinutes != 0 {
      let hour: Int = totalMinutes / 60
      let minute: Int = totalMinutes % 60
      return (hour, minute)
    } else {
      return (0, 0)
    }
  }
}

#Preview {
  RoutinePlanningView()
}
