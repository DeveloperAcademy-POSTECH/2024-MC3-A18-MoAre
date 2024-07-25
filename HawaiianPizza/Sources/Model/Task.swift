//
//  Task.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation

struct Task {
    var id: UUID = UUID()
    var taskTime: Date
    var taskSkipTime: Date
    var taskName: String
}
