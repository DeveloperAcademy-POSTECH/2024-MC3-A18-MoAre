//
//  DataProtocol.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation
import CoreData

protocol RoutineManaging {
    func createRoutine(routineTitle: String, tasks: [Tasks], routineTime: Int, totalSkipTime: Int) -> Routine
    func fetchAllRoutines() -> [Routine]
    func deleteRoutine(offsets: IndexSet, routines: [Routine])
}

protocol TaskManaging {
    func createTask(taskIcon: String, taskTime: Int?, taskSkipTime: Int?, taskName: String) -> Tasks
    func fetchAllTasks(for routine: Routine) -> [Tasks]
    func deleteTask(_ task: Tasks)
    func updateRoutine(routine: Routine, routineTitle: String, tasks: [Tasks], routineTime: Int, totalSkipTime: Int)
    func updateTask(task: Tasks, taskIcon: String, taskTime: Int?, taskSkipTime: Int?, taskName: String)
}

protocol TimeManaging {
    func createTime(startTime: Date) -> Time
    func fetchTime() -> Time?
    func deleteTime(_ time: Time)
    func updateTime(time: Time, startTime: Date)
}

protocol DataProtocol: RoutineManaging, TaskManaging, TimeManaging {
    func saveContext()
}
