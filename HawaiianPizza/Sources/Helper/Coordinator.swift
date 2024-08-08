//
//  File.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/30/24.
//

import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path: [ViewDestination] = []
    @Published var selectedRoutine: Routine? = nil
    
    func push(destination: ViewDestination, routine: Routine? = nil) {
        if let routine = routine {
            selectedRoutine = routine
        }
        path.append(destination)
        print("Path: \(path)")
        print("Selected Routine: \(String(describing: selectedRoutine))")
    }
    
    func pop() {
        path.removeLast()
        print("Path after pop: \(path)")
    }
    
    func popToRoot() {
        path.removeAll()
        print("Path after popToRoot: \(path)")
    }
    
    @ViewBuilder
    func setView(destination: ViewDestination) -> some View {
        switch destination {
        case .main:
            MainView()
                .navigationBarBackButtonHidden()
                .transaction { transaction in
                  transaction.disablesAnimations = true
                }
        case .routineSetting:
            RoutineSettingView()
        case .timer:
            if let routine = selectedRoutine {
                TimerView(routine: routine)
                    .navigationBarBackButtonHidden()
                    .onAppear {
                        if let routineID = routine.id?.uuidString {
                            print("TimerView 나타남 with routineID: \(routineID)")
                        }
                    }
            } else {
                Text("루틴이 선택되지 않았습니다.")
            }
        case .complete:
            if let routine = selectedRoutine {
                            CompleteView(routineID: routine.id)
                                .navigationBarBackButtonHidden()
                        } else {
                            Text("루틴이 선택되지 않았습니다.")
                        }
        case .routineDetail:
            if let routine = selectedRoutine {
                RoutineDetailView(routine: routine)
            } else {
                Text("루틴이 선택되지 않았습니다.")
            }
        }
    }
}
