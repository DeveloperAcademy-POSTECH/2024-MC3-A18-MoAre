import SwiftUI

struct RoutineDetailView: View {
    @EnvironmentObject var viewModel: RoutineSettingViewModel
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.editMode) var editMode
    
    @State private var isEditing: Bool = false
    var routine: Routine
    
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
                    Text("세부 설정")
                    Spacer()
                    Button {
                        viewModel.showModal.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                    .sheet(isPresented: $viewModel.showModal, content: {
                        AddTaskView()
                            .presentationDetents([
                                .fraction(0.47)
                            ])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(20)
                    })
                    
                }
                .font(.system(size: 24, weight: .bold))
                
                CreateTaskList()
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            CreateCompleteBtn()
                .navigationTitle("루틴 설정")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            
                        } label: {
                            Image("backIcon")
                                .resizable()
                                .scaledToFit()
                                .background(.blue)
                                .frame(width: 30, height: 30)
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
                                .background(.blue)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
        }
    }
}

extension RoutineDetailView {
    func CreateTaskList() -> some View {
        return List {
            ForEach(routine.tasksArray, id: \.id) { item  in
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
                                    Image(systemName: item.taskIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 29, height: 29)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 20)
                            
                            Text(item.taskName)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            if isEditing == false {
                                Button {
                                    viewModel.taskTimeDownUpdate(task: item)
                                } label: {
                                    Image(systemName: "arrowtriangle.backward.fill")
                                        .foregroundStyle(Color(hex: "#FF634B"))
                                }
                                .buttonStyle(PlainButtonStyle())

                                Text("\(item.taskTime)")
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                
                                Button {
                                    viewModel.taskTimeUpUpdate(task: item)
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
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            }
            .onDelete { _ in
            }
            .onMove { _,_  in
            }
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
    RoutineDetailView(routine: Routine())
}
