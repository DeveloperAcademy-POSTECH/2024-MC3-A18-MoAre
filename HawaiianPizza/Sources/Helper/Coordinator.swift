//
//  File.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/30/24.
//

import SwiftUI

final class Coordinator: ObservableObject {
  @Published var path: [ViewDestination] = []
  
  func push(destination: ViewDestination) {
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
      TimerView()
    case .complete:
      CompleteView()
    case .routineDetail:
      RoutineDetailView()
    }
  }
}
