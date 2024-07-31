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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
    var body: some Scene {
        WindowGroup {
                MainView()
                    .environmentObject(coordinator)
        }
    }
}
