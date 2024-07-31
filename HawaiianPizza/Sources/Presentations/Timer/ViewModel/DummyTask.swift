//
//  DummyTask.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/31/24.
//

import SwiftUI

struct DummyTask: Identifiable {
    var id: UUID = UUID()
    var taskTime: TimeInterval
    var taskSkipTime: TimeInterval
    var taskName: String
    var iconName: String
}
