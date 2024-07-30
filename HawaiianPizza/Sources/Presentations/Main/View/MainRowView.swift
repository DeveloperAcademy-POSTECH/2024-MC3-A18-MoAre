//
//  MainRowView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/29/24.
//

import SwiftUI
import Charts

struct MainRowView: View {
  let item: RoutineItem
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Text("\(item.title)")
          .font(.title3)
          .bold()
        
        Spacer()
      }
      
      HStack(alignment: .lastTextBaseline, spacing: 0) {
        Text("\(item.time.0)")
          .font(.system(size: 64))
          .padding(.trailing, 2)
        Text("hr")
          .font(.largeTitle)
          .foregroundStyle(Color(UIColor.systemGray))
          .padding(.trailing, 8)
        Text("\(item.time.1)")
          .font(.system(size: 64))
          .padding(.trailing, 2)
        Text("hr")
          .font(.largeTitle)
          .foregroundStyle(Color(UIColor.systemGray))
      }
      .padding(.top, 30)
      
      Chart {
        ForEach(item.chart.indices, id: \.self) { i in
          BarMark(x: .value("X", item.chart[i].ratio))
            .clipShape(shape())
            .foregroundStyle(Color.black)
            .foregroundStyle(color(forType: item.chart[i].type))
          
          if i != item.chart.count - 1 {
            BarMark(x: .value("Separator", 1))
              .foregroundStyle(.clear)
          }
        }
      }
      .chartXAxis {
        AxisMarks(values: .automatic(desiredCount: 0))
      }
      .frame(height: 52)
      .padding(.top, 24)
      
      Button(action: {
        
      }, label: {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(UIColor.systemGray2))
          .frame(height: 40)
          .overlay(
            Text("선택 완료")
              .font(.title2)
              .bold()
              .foregroundStyle(.black)
          )
      })
      .padding(.top, 30)
    }
    .padding(.top, 28)
    .padding(.bottom, 16)
    .padding(.horizontal, 24)
    .frame(width: 353)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color(UIColor.systemGray4))
    )
  }
  
  // 둘레가 둥그런 차트
  func shape() -> UnevenRoundedRectangle {
    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 10)
  }
  
  // 전부 이어진 차트
  func clipShape(forIndex i: Int) -> UnevenRoundedRectangle {
    if i == 0 {
      return UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10)
    } else if i == item.chart.count - 1 {
      return UnevenRoundedRectangle(bottomTrailingRadius: 10, topTrailingRadius: 10)
    } else {
      return UnevenRoundedRectangle()
    }
  }
  
  // 막대 색상 지정
  func color(forType type: RoutineType) -> Color {
    switch type {
    case .one:
      return .red
    case .two:
      return .yellow
    case .three:
      return .green
    }
  }
}
