//
//  DataProtocol.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation
import CoreData

protocol RoutineManaging {
    func createRoutine(routineTitle: String, routineTime: Date, totalSkipTime: Date) -> Routine
    func fetchAllRoutines() -> [Routine]
    func deleteRoutine(offsets: IndexSet, routines: [Routine])
}

protocol TaskManaging {
    func createTask(taskIcon: String, routine: Routine, taskTime: Date, taskSkipTime: Date, taskName: String) -> Task
    func fetchTasks(for routine: Routine) -> [Task]
    func deleteTask(_ task: Task)
}

protocol WeatherManaging {
    func createWeather(state: String) -> Weather
    func fetchAllWeather() -> [Weather]
    func deleteWeather(_ weather: Weather)
}

protocol TimeManaging {
    func createTime(startTime: Date) -> Time
    func fetchAllTimes() -> [Time]
    func deleteTime(_ time: Time)
}

protocol DataProtocol: RoutineManaging, TaskManaging, WeatherManaging, TimeManaging {
    func saveContext()
}
