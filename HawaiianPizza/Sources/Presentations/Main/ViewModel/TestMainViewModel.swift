import Foundation
import SwiftUI

class TestMainViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    
    init() {
        fetchRoutine()
    }
    
    func fetchRoutine() {
        routines = CoreDataManager.shared.fetchAllRoutines()
    }
}
