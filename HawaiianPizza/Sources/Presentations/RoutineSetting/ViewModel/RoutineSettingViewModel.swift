//
//  RoutineSettingViewModel.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//
import SwiftUI

class RoutineSettingViewModel: ObservableObject {
    @Published var showModal: Bool = false
    @Published var selectedIcon: String = ""
    
    @Published var routines: Routine?
    @Published var routineTitle: String = ""
    @Published var tasks: [Tasks] = [] {
        didSet {
            routineTime = calculateRoutineTime()
        }
    }
    @Published var routineTime: Int = 0
    @Published var totalSkipTime: Int = 0
    
    @Published var task: Tasks?
    @Published var tasktime: Int = 0
    @Published var taskTitle: String = ""
    @Published var taskIcon: String = ""
    @Published var iconArr = ["tornado", "cloud.sun", "moon", "cloud.bolt.fill", "cloud", "smoke", "rainbow", "wind"]
    
    func createTasks(taskIcon: String, taskName: String) -> UUID? {
        let task = CoreDataManager.shared.createTask(
            taskIcon: taskIcon,
            taskTime: tasktime,
            taskSkipTime: 0,
            taskName: taskName
        )
        tasks.append(task)
        routineTime = calculateRoutineTime()
        return task.id
    }
    
    func createRoutine(routineTitle: String, tasks: [Tasks], routineTime: Int, totalSkipTime: Int) {
        routines = CoreDataManager.shared.createRoutine(
            routineTitle: routineTitle,
            tasks: tasks,
            routineTime: routineTime,
            totalSkipTime: totalSkipTime
        )
    }
    
    func fetchTasks(routine: Routine) {
        tasks = CoreDataManager.shared.fetchAllTasks(for: routine)
        routineTime = calculateRoutineTime()
    }
    
    func taskTimeUpUpdate(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime += 5
            CoreDataManager.shared.saveContext()
            routineTime = calculateRoutineTime()
            objectWillChange.send()
        }
    }

    func taskTimeDownUpdate(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime = max(0, tasks[index].taskTime - 5)
            CoreDataManager.shared.saveContext()
            routineTime = calculateRoutineTime()
            objectWillChange.send()
        }
    }
    
    private func calculateRoutineTime() -> Int {
        return Int(tasks.reduce(0) { $0 + $1.taskTime })
       }
}
