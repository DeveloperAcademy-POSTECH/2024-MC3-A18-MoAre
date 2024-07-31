//
//  DataProtocol.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation
import CoreData

protocol RoutineManaging {
    func createRoutine(routineTitle: String, routineTime: Int, totalSkipTime: Int) -> Routine
    func fetchAllRoutines() -> [Routine]
    func deleteRoutine(offsets: IndexSet, routines: [Routine])
}

protocol TaskManaging {
    func createTask(taskIcon: String, routine: Routine, taskTime: Int, taskSkipTime: Int, taskName: String) -> Task
    func fetchTasks(for routine: Routine) -> [Task]
    func deleteTask(_ task: Task)
}

protocol TimeManaging {
    func createTime(startTime: Date) -> Time
    func fetchAllTimes() -> [Time]
    func deleteTime(_ time: Time)
}

protocol DataProtocol: RoutineManaging, TaskManaging, TimeManaging {
    func saveContext()
}
