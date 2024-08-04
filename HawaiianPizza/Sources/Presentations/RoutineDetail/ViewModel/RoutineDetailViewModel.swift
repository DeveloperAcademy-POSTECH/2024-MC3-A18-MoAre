//
//  RoutineDetailViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 8/3/24.
//

import SwiftUI

class RoutineDetailViewModel: ObservableObject {
    @Published var showModal: Bool = false
    @Published var selectedIcon: String = ""
    
    @Published var routines: Routine
    @Published var routineTitle: String
    @Published var tasks: [Tasks] {
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
    
    init(routine: Routine) {
        self.routines = routine
        self.routineTitle = routine.routineTitle ?? ""
        self.tasks = routine.tasksArray
    }
    
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
    
    func deleteTasks(atOffsets offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasks[index]
            CoreDataManager.shared.deleteTask(task)
        }
        tasks.remove(atOffsets: offsets)
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
    }
    
    func moveTasks(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        tasks.move(fromOffsets: offsets, toOffset: offset)
        CoreDataManager.shared.saveContext()
        objectWillChange.send()
    }
    
    func taskTimeUpUpdate(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime += 5
            routineTime = calculateRoutineTime()
            CoreDataManager.shared.saveContext()
            objectWillChange.send()
        }
    }
    
    func taskTimeDownUpdate(task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].taskTime = max(0, tasks[index].taskTime - 5)
            routineTime = calculateRoutineTime()
            CoreDataManager.shared.saveContext()
            objectWillChange.send()
        }
    }
    
    func updateRoutine(title: String, tasks: [Tasks]) {
        CoreDataManager.shared.updateRoutine(routine: routines, routineTitle: title, tasks: tasks, routineTime: routineTime, totalSkipTime: totalSkipTime)
    }
    
    func updateTask(task: Tasks, taskIcon: String, taskTime: Int, taskSkipTime: Int, taskName: String) {
        CoreDataManager.shared.updateTask(task: task, taskIcon: taskIcon, taskTime: taskTime, taskSkipTime: taskSkipTime, taskName: taskName)
    }
    
    private func calculateRoutineTime() -> Int {
        return Int(tasks.reduce(0) { $0 + $1.taskTime })
    }
}
