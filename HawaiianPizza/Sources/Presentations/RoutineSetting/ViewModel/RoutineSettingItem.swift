//
//  RoutineSettingItem.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import Foundation
import SwiftUI

struct RoutineSettingItem: Identifiable {
  let id = UUID()
  var icon: String
  var title: String
  
  static func == (lhs: RoutineSettingItem, rhs: RoutineSettingItem) -> Bool {
    lhs.id == rhs.id
  }
}
