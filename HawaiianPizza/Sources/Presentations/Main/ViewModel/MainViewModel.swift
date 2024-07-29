//
//  MainViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
  @Published var items: [RoutineItem] = [
    RoutineItem(title: "Daily Routine", time: (1, 10), chart: [
      TaskItem(task: "일어나기", type: .one, ratio: 28),
      TaskItem(task: "샤워하기", type: .two, ratio: 57),
      TaskItem(task: "스킨케어", type: .three, ratio: 14),
      TaskItem(task: "옷 입기", type: .one, ratio: 5)
    ]),
    RoutineItem(title: "Special Routine", time: (2, 40), chart: [
      TaskItem(task: "샤워하기", type: .one, ratio: 50),
      TaskItem(task: "스킨케어", type: .two, ratio: 20),
      TaskItem(task: "메이크업", type: .three, ratio: 70),
      TaskItem(task: "옷 입기", type: .one, ratio: 10)
    ])
  ]
}
