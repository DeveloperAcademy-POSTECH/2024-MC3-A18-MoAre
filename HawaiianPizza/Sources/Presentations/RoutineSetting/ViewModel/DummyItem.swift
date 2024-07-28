//
//  ListItem.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import Foundation
import SwiftUI

struct DummyItem: Identifiable {
  let id = UUID()
  var icon: String
  var title: String
  
  static func == (lhs: DummyItem, rhs: DummyItem) -> Bool {
    lhs.id == rhs.id
  }
}
