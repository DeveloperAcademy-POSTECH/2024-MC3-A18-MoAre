//
//  CompleteViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Foundation

class CompleteViewModel: ObservableObject {
    @Published var completeRoutine: Routine?
    
    init() {
        fetchRoutines(selectedRoutineID: nil)
    }
    
    // 이게 차후에 Routine 타이머가 다 돌아가고 나서 선택된 루틴의 ID와 같은지 확인하고 같을 때 completeRoutine으로 할당
    // completeRoutine을 View에 바인딩해서 completeRoutine.totalSkipTime을 표출
    func fetchRoutines(selectedRoutineID: UUID?) {
        let routines = CoreDataManager.shared.fetchAllRoutines()
        completeRoutine = routines.first(where: { $0.id == selectedRoutineID })
    }
}
