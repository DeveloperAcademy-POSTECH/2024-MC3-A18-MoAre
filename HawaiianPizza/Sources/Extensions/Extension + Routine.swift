//
//  Extension + Routine.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 8/2/24.
//

import Foundation

extension Routine {
    var tasksArray: [Tasks] {
        let set = tasks as? Set<Tasks> ?? []
        return Array(set)
    }
}
