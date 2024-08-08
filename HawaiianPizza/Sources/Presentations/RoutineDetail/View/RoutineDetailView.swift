//
//  RoutineDetailView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//

import SwiftUI

struct RoutineDetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: RoutineDetailViewModel
    @Environment(\.editMode) var editMode
    
    @State private var isEditing: Bool = false
    
    init(routine: Routine) {
        _viewModel = StateObject(wrappedValue: RoutineDetailViewModel(routine: routine))
    }
    
    var body: some View {
        VStack {
            TextField("루틴명", text: $viewModel.routineTitle)
                .padding(.top, 20)
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
                .onAppear {
                    UIApplication.shared.hideKeyboard()
                }
            
            Divider()
                .frame(height: 2)
                .background(.black)
                .padding(.bottom, 35)
                .padding(.horizontal, 16)
            
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
                    UpdateTaskView(viewModel: viewModel)
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

extension RoutineDetailView {
    private func CreateTaskList() -> some View {
        List {
            ForEach($viewModel.tasks, id: \.id) { task in
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
                                    Image(task.taskIcon.wrappedValue ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 20)
                            
                            Text(task.taskName.wrappedValue ?? "")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            if !isEditing {
                                Button {
                                    viewModel.taskTimeDownUpdate(task: task.wrappedValue)
                                } label: {
                                    Image(systemName: "arrowtriangle.backward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Text("\(task.taskTime.wrappedValue)")
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                
                                Button {
                                    viewModel.taskTimeUpUpdate(task: task.wrappedValue)
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
            .onDelete { indexSet in
                viewModel.deleteTasks(atOffsets: indexSet)
            }
            .onMove { indexSet, newOffset in
                viewModel.moveTasks(fromOffsets: indexSet, toOffset: newOffset)
            }
        }
        .listStyle(.plain)
    }
    
    private func CreateCompleteBtn() -> some View {
        Button {
            viewModel.updateRoutine(title: viewModel.routineTitle, tasks: viewModel.tasks)
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
