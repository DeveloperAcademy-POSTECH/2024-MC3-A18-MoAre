//
//  RoutineSettingView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//

import SwiftUI

struct RoutineSettingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = RoutineSettingViewModel()
    @Environment(\.editMode) var editMode
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            TextField("루틴명", text: $viewModel.routineTitle)
                .padding(.top, 20)
                .padding(.bottom, 8)
            
            Divider()
                .frame(height: 2)
                .background(.black)
                .padding(.bottom, 35)
            
            HStack {
                Text("DETAIL")
                
                Spacer()
                
                Button {
                    viewModel.showModal.toggle()
                } label: {
                    Image("plusIcon")
                        .foregroundStyle(.black)
                }
                .sheet(isPresented: $viewModel.showModal, content: {
                    AddTaskView(viewModel: viewModel)
                        .presentationDetents([
                            .fraction(0.46)
                        ])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(20)
                })
                
            }
            .font(.system(size: 24, weight: .bold))
            .padding(.horizontal, 16)

            CreateTaskList()
            
            Spacer()
        }
        
        CreateCompleteBtn()
            .navigationTitle("루틴 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        coordinator.pop()
                    } label: {
                        Image("backIcon")
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isEditing.toggle()
                            editMode?.wrappedValue = isEditing ? .active : .inactive
                        }
                    } label: {
                        Image("editIcon")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
    }
}

extension RoutineSettingView {
    private func CreateTaskList() -> some View {
        List {
            ForEach(viewModel.tasks, id: \.id) { task in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#36383A"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .overlay {
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(hex: "#D3D7DA"))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: task.taskIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 29, height: 29)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 20)
                            
                            Text(task.taskName)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            if !isEditing {
                                Button {
                                    viewModel.taskTimeDownUpdate(task: task)
                                } label: {
                                    Image(systemName: "arrowtriangle.backward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                }
                                .buttonStyle(PlainButtonStyle())

                                Text("\(task.taskTime)")
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)

                                Button {
                                    viewModel.taskTimeUpUpdate(task: task)
                                } label: {
                                    Image(systemName: "arrowtriangle.forward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                        .padding(.trailing, 20)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete { _ in }
            .onMove { _,_  in }
        }
        .listStyle(.plain)
    }
    
    private func CreateCompleteBtn() -> some View {
        Button {
            viewModel.createRoutine(
                routineTitle: viewModel.routineTitle,
                tasks: viewModel.tasks,
                routineTime: viewModel.routineTime,
                totalSkipTime: viewModel.totalSkipTime
            )
            if let routine = viewModel.routines {
                print("루틴 저장: \(routine)")
            }
            coordinator.popToRoot()
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
    RoutineSettingView()
        .environmentObject(Coordinator())
}
