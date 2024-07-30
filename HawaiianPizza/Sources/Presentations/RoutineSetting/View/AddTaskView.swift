//
//  AddTaskView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import SwiftUI

struct AddTaskView: View {
  @Binding var newTaskTitle: String
  @Binding var newTaskIcon: String
  @State var selectedIcon: Icon?
  private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  var onAdd: () -> Void
  
  init(newTaskTitle: Binding<String>, newTaskIcon: Binding<String>, onAdd: @escaping () -> Void) {
    self._newTaskTitle = newTaskTitle
    self._newTaskIcon = newTaskIcon
    self.onAdd = onAdd
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
      
      VStack(spacing: 0) {
        TextField("태스크명", text: $newTaskTitle)
          .font(.system(.title3).bold())
          .padding()
          .background(Color(UIColor.systemGray4))
          .cornerRadius(10)
          .padding(.bottom, 8)
        
        LazyVGrid(columns: columns) {
          ForEach(Icon.allCases, id: \.self) { icon in
            Button(action: {
              selectedIcon = icon
              newTaskIcon = icon.icon
            },
            label: {
              // MARK: - 수정 필요 : 한 번 더 눌렀을 경우 취소되도록
              TaskIconView(icon: icon, isSelected: selectedIcon == icon ? true : false)
            })
          }
        }
        
        Button(action: {
          onAdd()
        }, label: {
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(height: 50)
              .foregroundStyle(Color(UIColor.systemGray))
            
            Text("완료")
              .font(.title2)
              .foregroundStyle(.black)
              .bold()
          }
          .padding(.vertical, 19)
        })
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea()
  }
}

//#Preview {
//  AddTaskView()
//}
