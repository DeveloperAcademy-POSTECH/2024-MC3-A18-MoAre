//
//  PlanningCellView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/25/24.
//

import SwiftUI

// MARK: - 부리 : 개별 잔디 뷰
struct PlanningCellView: View {
  let isSelected: Bool
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(isSelected ? Color.gray : Color(UIColor.systemGray4))
      .frame(width: 50, height: 50)
  }
}

#Preview {
  PlanningCellView(isSelected: false)
}
