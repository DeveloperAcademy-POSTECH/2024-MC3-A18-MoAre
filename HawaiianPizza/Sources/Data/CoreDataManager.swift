//
//  CoreDataManager.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    let viewContext:NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "HawaiianPizza")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        viewContext = persistentContainer.viewContext
    }
}

extension CoreDataManager: DataProtocol {
    // MARK: - Save Context
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Routine Methods
    func createRoutine(routineTitle: String, routineTime: Int, totalSkipTime: Int) -> Routine {
        let routine = Routine(context: viewContext)
        routine.id = UUID()
        routine.routineTitle = routineTitle
        routine.routineTime = Int32(routineTime)
        routine.totalSkipTime = Int32(totalSkipTime)
        saveContext()
        return routine
    }
    
    func fetchAllRoutines() -> [Routine] {
        let request: NSFetchRequest<Routine> = Routine.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch routines: \(error)")
            return []
        }
    }
    
//    func deleteRoutine(_ routine: Routine) {
//        viewContext.delete(routine)
//        saveContext()
//    }
    
    func deleteRoutine(offsets: IndexSet, routines: [Routine]) {
            offsets.map { routines[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    
    // MARK: - Task Methods
    func createTask(taskIcon: String, routine: Routine, taskTime: Int, taskSkipTime: Int, taskName: String) -> Tasks {
        let task = Tasks(context: viewContext)
        task.id = UUID()
        task.taskIcon = taskIcon
        task.routine = routine
        task.taskTime = Int32(taskTime)
        task.taskSkipTime = Int32(taskSkipTime)
        task.taskName = taskName
        saveContext()
        return task
    }
    
    func fetchTasks(for routine: Routine) -> [Tasks] {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        request.predicate = NSPredicate(format: "routine == %@", routine)
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func deleteTask(_ task: Tasks) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Time Methods
    func createTime(startTime: Date) -> Time {
        let time = Time(context: viewContext)
        time.startTime = startTime
        saveContext()
        return time
    }
    
    func fetchAllTimes() -> [Time] {
        let request: NSFetchRequest<Time> = Time.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch times: \(error)")
            return []
        }
    }
    
    func deleteTime(_ time: Time) {
        viewContext.delete(time)
        saveContext()
    }
}
