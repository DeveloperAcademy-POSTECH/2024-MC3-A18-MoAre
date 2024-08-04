//
//  MainRowView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/29/24.
//

import SwiftUI
import Charts

struct MainRowView: View {
  let title: String
  let duration: Int
  let widthRatio: CGFloat
  let isSelected: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      Text(title)
            .font(Font.system(size: 20))
        .fontWeight(.semibold)
        .frame(width: 70, alignment: .leading)
        .lineLimit(1)
        .padding(.trailing, 20)
      
      GeometryReader { geometry in
        HStack(spacing: 0) {
          RoundedRectangle(cornerRadius: 4)
            .fill(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
            .frame(width: geometry.size.width * widthRatio, height: 24)
            .padding(.trailing, 12)
          Text("\(duration)m")
            .foregroundStyle(isSelected ? Color(red: 1, green: 0.39, blue: 0.29) : Color(red: 0.6, green: 0.62, blue: 0.64))
            .font(Font.system(size: 18))
            .fontWeight(.semibold)
        }
      }
      .frame(height: 24)
    }
  }
}

#Preview {
  MainRowView(title: "일어나기", duration: 30, widthRatio: 0.3, isSelected: false)
}
