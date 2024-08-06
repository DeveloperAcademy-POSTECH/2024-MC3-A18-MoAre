//
//  AppDelegate.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import UIKit
import SwiftUI
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  var window: UIWindow?
  var localNotificationManager: LocalNotificationManager?
  
//  @EnvironmentObject var localNotificationManager: LocalNotificationManager
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return true
  }
  
  func configure(localNotificationManager: LocalNotificationManager) {
    self.localNotificationManager = localNotificationManager
  }
  
  // 알림 눌렀을 때 호출되는 메소드
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    guard let localNotificationManager = localNotificationManager else {
      completionHandler()
      return
    }
    
    if let routineID = response.notification.request.content.userInfo["routineID"] as? String {
      DispatchQueue.main.async {
        localNotificationManager.selectedRoutineID = routineID
        localNotificationManager.navigateToView = true
      }
    }
    cancelAllNotifications()
    completionHandler()
  }
  
  func navigateToTenSecView() {
    let tenSecView = TenSecView()
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let keyWindow = windowScene.windows.first {
      keyWindow.rootViewController = UIHostingController(rootView: tenSecView)
      keyWindow.makeKeyAndVisible()
    }
  }
  
  func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
