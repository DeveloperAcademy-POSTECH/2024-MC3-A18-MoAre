//
//  AddTaskViewModel.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import Foundation
import SwiftUI

// MARK: - task icon 임의 지정 변환 가능
enum Icon: String, CaseIterable {
  case wakeup
  case shower
  case skincare
  case makeup
  case wearclothes
  case takemedicine
  case bagpacking
  case etc
}

extension Icon {
  var icon: String {
    switch self {
    case .wakeup:
      return "tshirt"
    case .shower:
      return "tshirt"
    case .skincare:
      return "tshirt"
    case .makeup:
      return "tshirt"
    case .wearclothes:
      return "tshirt"
    case .takemedicine:
      return "tshirt"
    case .bagpacking:
      return "tshirt"
    case .etc:
      return "tshirt"
    }
  }
}

class AddTaskViewModel: ObservableObject {
  
}
