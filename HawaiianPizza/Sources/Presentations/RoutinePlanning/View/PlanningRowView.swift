//
//  PlanningRowView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/25/24.
//

import SwiftUI

// MARK: - 부리 : 잔디 심기 한 줄 뷰
struct PlanningRowView: View {
  let rowIndex: Int // 전 페이지에서 전달
  @State private var selectedIndices: [Bool] = Array(repeating: false, count: 5)
  @Binding var totalMinutes: Int
  @State private var rowTotalMinutes: Int = 0
  
  var body: some View {
    HStack(spacing: 0) {
      ZStack() {
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(UIColor.systemGray2))
          .frame(width: 50, height: 50)
        
        // 추후에 이미지로 수정
        Image(systemName: "tshirt")
          .resizable()
          .frame(width: 30, height: 25)
          .padding()
      }
      .padding(.trailing, 10)
      
      ForEach(0..<5) { colIndex in
        PlanningCellView(isSelected: selectedIndices[colIndex])
          .padding(.trailing, 8)
          .onTapGesture {
            handleTap(at: colIndex)
          }
      }
    }
    .onChange(of: selectedIndices) {
      updateTotalMinutes()
    }
  }
  
  private func handleTap(at index: Int) {
    if selectedIndices[index] {
      for i in index..<5 {
        selectedIndices[i] = false
      }
    } else {
      for i in 0...index {
        selectedIndices[i] = true
      }
    }
  }
  
  private func updateTotalMinutes() {
    let selectedCount = selectedIndices.filter { $0 }.count
    let newRowTotalMinutes = selectedCount * 5
    totalMinutes += (newRowTotalMinutes - rowTotalMinutes)
    rowTotalMinutes = newRowTotalMinutes
  }
}

#Preview {
  PlanningRowView(rowIndex: 5, totalMinutes: .constant(0))
}
