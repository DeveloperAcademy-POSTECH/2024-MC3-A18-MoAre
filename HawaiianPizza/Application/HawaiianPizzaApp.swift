//
//  HawaiianPizzaApp.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

@main
struct HawaiianPizzaApp: App {
    @StateObject var coordinator = Coordinator()
    @StateObject var localNotificationManager = LocalNotificationManager()
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(coordinator)
                .environmentObject(localNotificationManager)
                .onAppear {
                    appDelegate.configure(localNotificationManager: localNotificationManager)
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
          if newPhase == .active {
            if localNotificationManager.navigateToView, let routineID = localNotificationManager.selectedRoutineID {
              localNotificationManager.navigateToView = true
            }
          }
        }
    }
}
