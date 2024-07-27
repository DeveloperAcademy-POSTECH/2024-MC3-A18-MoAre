//
//  AddTaskView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import SwiftUI

struct AddTaskView: View {
  @State var taskTitle: String = ""
  @State var selectedIcon: Icon?
  private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  
  var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
      
      VStack(spacing: 0) {
        TextField("태스크명", text: $taskTitle)
          .font(.system(.title3).bold())
          .padding()
          .background(Color(UIColor.systemGray4))
          .cornerRadius(10)
          .padding(.bottom, 8)
        
        LazyVGrid(columns: columns) {
          ForEach(Icon.allCases, id: \.self) { icon in
            Button(action: {
              selectedIcon = icon
            },
            label: {
              // MARK: - 수정 필요 : 한 번 더 눌렀을 경우 취소되도록
              TaskIconView(icon: icon, isSelected: selectedIcon == icon ? true : false)
            })
          }
        }
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  AddTaskView()
}
