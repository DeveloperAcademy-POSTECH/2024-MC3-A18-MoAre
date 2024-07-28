//
//  TaskCellView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import SwiftUI

struct TaskIconView: View {
  let icon: Icon
  var isSelected: Bool = false
  
  var body: some View {
    ZStack {
      if isSelected {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(UIColor.systemGray4))
      } else {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(UIColor.secondarySystemBackground))
          .frame(width: 80, height: 80)
          .cornerRadiusWithBorder(radius: 10, borderColor: Color(UIColor.systemGray4), lineWidth: 3)
      }
      
      Image(systemName: icon.icon)
        .resizable()
        .frame(width:55, height: 40)
        .foregroundStyle(Color.black)
    }
  }
}

#Preview {
  TaskIconView(icon: Icon.wearclothes)
}
