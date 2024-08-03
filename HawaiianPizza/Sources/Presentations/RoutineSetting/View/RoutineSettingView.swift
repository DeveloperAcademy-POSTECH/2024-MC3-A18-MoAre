//
//  RoutineSettingView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//

import SwiftUI

struct RoutineSettingView: View {
    @EnvironmentObject var viewModel: RoutineSettingViewModel
    
    var body: some View {
        NavigationStack {
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
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                    .sheet(isPresented: $viewModel.showModal, content: {
                        AddTaskView(viewModel: viewModel)
                            .presentationDetents([
                                .fraction(0.47)
                            ])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(20)
                    })
                    
                }
                .font(.system(size: 24, weight: .bold))
                
                ForEach(viewModel.tasks, id: \.id) { item in
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
                                        Image(systemName: item.taskIcon ?? "")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 29, height: 29)
                                    }
                                    .padding(.leading, 12)
                                    .padding(.trailing, 20)
                                
                                Text(item.taskName ?? "")
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.timeDown(task: item)
                                } label: {
                                    Image(systemName: "arrowtriangle.backward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                }
                                
                                Text("\(viewModel.tasktime)")
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                
                                Button {
                                    viewModel.timeUp(task: item)
                                } label: {
                                    Image(systemName: "arrowtriangle.forward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 16)
            
            Button {
                viewModel.createRoutine(
                    routineTitle: viewModel.routineTitle,
                    tasks: viewModel.tasks,
                    routineTime: viewModel.routineTime,
                    totalSkipTime: viewModel.totalSkipTime
                )
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
            .navigationTitle("SETTING ROUTINE")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RoutineSettingView()
}
