//
//  HawaiianPizzaApp.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

@main
struct HawaiianPizzaApp: App {
    @StateObject private var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
//            MainView()
//            CoreDataTestView()
            //            WeatherTestView()
            NavigationStack(path:$coordinator.path) {
                MainView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: ViewDestination.self){ destination in
                        coordinator.setView(destination: destination)
                    }
            }
        }
    }
}
