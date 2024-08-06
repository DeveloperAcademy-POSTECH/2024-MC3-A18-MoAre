//
//  HawaiianPizzaApp.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

@main
struct HawaiianPizzaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var coordinator = Coordinator()
    @StateObject var localNotificationManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(coordinator)
                .environmentObject(localNotificationManager)
                .onAppear {
                    localNotificationManager.requestPermission()
                }
                .fullScreenCover(isPresented: $localNotificationManager.navigateToView) {
                  TenSecView(routineID: localNotificationManager.selectedRoutineID)
                        .environmentObject(coordinator)
                        .environmentObject(localNotificationManager)
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
        }
    }
}
