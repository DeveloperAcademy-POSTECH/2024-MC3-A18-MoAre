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
          TimerView()
            .environmentObject(localNotificationManager)
        }
        .transaction { transaction in
          transaction.disablesAnimations = true
        }
    }
  }
}
