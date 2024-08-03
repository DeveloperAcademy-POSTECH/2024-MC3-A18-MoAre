//
//  AddTaskView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: RoutineSettingViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            TextField("태스크명", text: $viewModel.taskTitle)
                .font(Font.system(size: 20, weight: .bold))
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 2)
                .background(Color.black)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: columns, spacing: 11) {
                ForEach(viewModel.iconArr, id: \.self) { icon in
                    Button {
                        viewModel.taskIcon = icon
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#F2F2EF"))
                            .frame(width: 80, height: 80)
                            .overlay {
                                Image(systemName: icon)
                                    .resizable()
                                    .frame(width: 50, height: 50)
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

extension AddTaskView {
    func CreateCompleteBtn() -> some View {
        return Button {
            viewModel.createTasks(taskIcon: viewModel.taskIcon, taskName: viewModel.taskTitle)
            viewModel.showModal.toggle()
            print("테스크 저장: \(viewModel.tasks)")
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
    AddTaskView(viewModel: RoutineSettingViewModel())
}
