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
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func setView(destination: ViewDestination) -> some View {
        switch destination {
        case .main:
            MainView()
        case .routineSetting:
            RoutineSettingView()
        case .routinePlanning:
            RoutinePlanningView()
        case .timer:
            if let routine = selectedRoutine {
              TimerView(routine: routine)
                    .navigationBarBackButtonHidden()
            }
        case .complete:
            CompleteView()
        case .routineDetail:
            if let routine = selectedRoutine {
                RoutineDetailView(routine: routine)
            }
      }
   }
}
