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
                  
                  localNotificationManager.navigateToView = false
                  localNotificationManager.selectedRoutineID = nil
                }
                .fullScreenCover(isPresented: $localNotificationManager.navigateToView, onDismiss: {
                  localNotificationManager.navigateToView = false
                }) {
                  if let routineID = localNotificationManager.selectedRoutineID {
                    TenSecView(routineID: routineID)
                      .environmentObject(coordinator)
                      .environmentObject(localNotificationManager)
                  }
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
          if newPhase == .active {
            if localNotificationManager.navigateToView, let _ = localNotificationManager.selectedRoutineID {
              localNotificationManager.navigateToView = true
            }
          }
        }
    }
}
