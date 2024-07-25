//
//  CoreDataTestViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import Foundation

class CoreDataTestViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    
    init() {
        fetchRoutines()
    }
    
    func addRoutine(routineTitle: String, routineTime: Date, skipTime: Date) {
        let newRoutine = CoreDataManager.shared.createRoutine(
            routineTitle: routineTitle,
            routineTime: routineTime,
            totalSkipTime: skipTime
        )
        
        routines.append(newRoutine)
        fetchRoutines()
    }
    
    func fetchRoutines() {
        routines = CoreDataManager.shared.fetchAllRoutines()
    }
    
    func deleteRoutines(offset: IndexSet) {
        CoreDataManager.shared.deleteRoutine(offsets: offset, routines: routines)
        fetchRoutines()
    }
}
