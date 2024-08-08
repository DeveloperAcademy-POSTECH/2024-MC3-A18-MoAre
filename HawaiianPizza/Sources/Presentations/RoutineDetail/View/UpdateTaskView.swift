//
//  UpdateTaskView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 8/3/24.
//

import SwiftUI

struct UpdateTaskView: View {
    @ObservedObject var viewModel: RoutineDetailViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            TextField("태스크명", text: $viewModel.taskTitle)
                .font(Font.system(size: 20, weight: .bold))
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
                .onChange(of: viewModel.taskTitle) { oldValue, newValue in
                    if newValue.count >= 6 {
                        viewModel.taskTitle = String(newValue.prefix(6))
                    }
                }
            Divider()
                .frame(height: 2)
                .background(Color.black)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: columns, spacing: 11) {
                ForEach(viewModel.iconArr, id: \.self) { icon in
                    Button {
                        viewModel.taskIcon = icon
                        viewModel.selectedIcon = icon
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.selectedIcon == icon ? Color(hex: "#FF634B") : Color(hex: "#F2F2EF"))
                            .frame(width: 80, height: 80)
                            .overlay {
                                Image(icon)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.black)
                            }
                    }
                }
            }
            .padding(.bottom, 22.26)
            .padding(.horizontal, 20)
            
            CreateCompleteBtn()
        }
    }
}

extension UpdateTaskView {
    func CreateCompleteBtn() -> some View {
        
        return Button {
            viewModel.createTasks(taskIcon: viewModel.taskIcon, taskName: viewModel.taskTitle)
            viewModel.showModal.toggle()
        } label: {
            Rectangle()
                .fill(Color(hex: "#FF634B"))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .overlay {
                    Text("완료")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }
        }
    }
}

#Preview {
    UpdateTaskView(viewModel: RoutineDetailViewModel(routine: Routine()))
}
