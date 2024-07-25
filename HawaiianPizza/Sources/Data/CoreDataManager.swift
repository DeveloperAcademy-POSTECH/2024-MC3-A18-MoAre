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
    func createRoutine(routineTitle: String, routineTime: Date, totalSkipTime: Date) -> Routine {
        let routine = Routine(context: viewContext)
        routine.id = UUID()
        routine.routineTitle = routineTitle
        routine.routineTime = routineTime
        routine.totalSkipTime = totalSkipTime
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
    func createTask(routine: Routine, taskTime: Date, taskSkipTime: Date, taskName: String) -> Task {
        let task = Task(context: viewContext)
        task.id = UUID()
        task.routine = routine
        task.taskTime = taskTime
        task.taskSkipTime = taskSkipTime
        task.taskName = taskName
        saveContext()
        return task
    }
    
    func fetchTasks(for routine: Routine) -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "routine == %@", routine)
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Weather Methods
    func createWeather(state: String) -> Weather {
        let weather = Weather(context: viewContext)
        weather.state = state
        saveContext()
        return weather
    }
    
    func fetchAllWeather() -> [Weather] {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch weather: \(error)")
            return []
        }
    }
    
    func deleteWeather(_ weather: Weather) {
        viewContext.delete(weather)
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
