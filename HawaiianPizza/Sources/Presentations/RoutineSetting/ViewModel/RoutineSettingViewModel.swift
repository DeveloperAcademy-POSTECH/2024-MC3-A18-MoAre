//
//  RoutineSettingViewModel.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//
import SwiftUI

class RoutineSettingViewModel: ObservableObject {
    @Published var showModal: Bool = false
    
    @Published var selectedRoutine: Routine?
    @Published var routineTitle: String = ""
    @Published var tasks: [Tasks] = []
    @Published var routineTime: Int = 0
    @Published var totalSkipTime: Int = 0
    
    @Published var task: Tasks?
    @Published var tasktime: Int = 0
    @Published var taskTitle: String = ""
    @Published var taskIcon: String = ""
    @Published var iconArr = ["tornado", "cloud.sun", "moon", "cloud.bolt.fill", "cloud", "smoke", "rainbow", "wind"]
    
    func createTasks(taskIcon: String, taskTime: Int, taskName: String) {
        task = CoreDataManager.shared.createTask(
            taskIcon: taskIcon,
            taskTime: taskTime,
            taskSkipTime: 0,
            taskName: taskName
        )
        if let task = task {
            tasks.append(task)
        }
    }
    
    func createRoutine(routineTitle: String, tasks: [Tasks], routineTime: Int, totalSkipTime: Int) {
        _ = CoreDataManager.shared.createRoutine(
            routineTitle: routineTitle,
            tasks: tasks,
            routineTime: routineTime,
            totalSkipTime: totalSkipTime
        )
    }
    
    func fetchTasks(routine: Routine) {
        tasks = CoreDataManager.shared.fetchTasks(for: routine)
    }
    
    func updateTaskTime(task: Tasks, time: Int) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime = Int32(time)
        }
    }
    
   
    func timeUp(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime += 5
            objectWillChange.send()
        }
    }

    func timeDown(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime = max(0, tasks[index].taskTime - 5)
            objectWillChange.send()
        }
    }
}
