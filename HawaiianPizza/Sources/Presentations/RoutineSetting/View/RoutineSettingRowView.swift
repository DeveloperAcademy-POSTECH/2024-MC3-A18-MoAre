//
//  RoutineSettingRowView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import SwiftUI

struct RoutineSettingRowView: View {
  let item: DummyItem
  let onDelete: () -> Void
  
  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        onDelete()
      }, label: {
        Image(systemName: "minus.circle.fill")
          .resizable()
          .frame(width: 25, height: 25)
          .foregroundStyle(.black)
      })
      .buttonStyle(BorderlessButtonStyle())
      .padding(.trailing, 12)
      .contentShape(Rectangle())
      
      ZStack {
        RoundedRectangle(cornerRadius: 5)
          .frame(width: 40, height: 40)
          .foregroundStyle(Color(UIColor.systemGray4))
        
        Image(systemName: "\(item.icon)")
          .resizable()
          .frame(width: 29, height: 23)
      }
      .frame(width: 40, height: 40)
      .padding(.trailing, 20)
      
      Text("\(item.title)")
        .font(.title2)
        .bold()
      
      Spacer()
    }
    .padding(10)
  }
}
