//
//  Routine.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation

struct Routine {
    var id: UUID = UUID()
    var routineTitle: String
    var tasks: [Task]
    var routineTime: Date
    var totalSkipTime: Date
}

