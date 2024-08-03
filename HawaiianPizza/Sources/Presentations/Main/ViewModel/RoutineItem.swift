//
//  RoutineItem.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/29/24.
//

import Foundation
import SwiftUI
import Charts

enum RoutineType: String, Plottable {
  // 나중에 색 구분하는 건 이걸 쓰면 될 것 같음
  case one, two, three
}

struct TaskItem: Identifiable {
  let id = UUID()
  var task: String
  var type: RoutineType
  var ratio: Int
}

struct RoutineItem: Identifiable {
  let id = UUID()
  var title: String
  var time: (hour: Int, minute: Int)
  var chart: [TaskItem]
}
