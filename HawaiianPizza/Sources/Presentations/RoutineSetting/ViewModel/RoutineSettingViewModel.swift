//
//  RoutineSettingViewModel.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import Foundation
import SwiftUI

class RoutineSettingViewModel: ObservableObject {
  // Dummy~
  @Published var items: [RoutineSettingItem] = [
    RoutineSettingItem(icon: "tshirt", title: "샤워하기"),
    RoutineSettingItem(icon: "tshirt", title: "일어나기"),
    RoutineSettingItem(icon: "tshirt", title: "스킨케어"),
    RoutineSettingItem(icon: "tshirt", title: "화장과 머리"),
    RoutineSettingItem(icon: "tshirt", title: "옷입기")
  ]
  
  func delete(item: RoutineSettingItem) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items.remove(at: index)
    }
  }
  
  func move(from source: IndexSet, to destination: Int) {
    items.move(fromOffsets: source, toOffset: destination)
  }
}
