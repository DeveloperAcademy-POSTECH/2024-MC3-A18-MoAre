//
//  RoutineItem.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/29/24.
//

import Foundation
import SwiftUI
import Charts

struct TaskItem: Identifiable {
  let id = UUID()
  var taskIcon: String
  var taskName: String
  var taskSkipTime: Int
  var taskTime: Int
}

struct RoutineItem: Identifiable {
  let id = UUID()
  var routineTime: Int
  var routineTitle: String
  var totalSkipTime: Int
  var tasks: [TaskItem]
}
