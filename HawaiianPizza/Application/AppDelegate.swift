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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    _ = LocationHelper.shared
    
    if let notificationResponse = launchOptions?[.remoteNotification] as? UNNotificationResponse {
      handleNotification(userInfo: notificationResponse.notification.request.content.userInfo)
    }
    return true
  }
  
  func configure(localNotificationManager: LocalNotificationManager) {
    self.localNotificationManager = localNotificationManager
  }
  
  // 알림 눌렀을 때 호출되는 메소드
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    handleNotification(userInfo: response.notification.request.content.userInfo)
    cancelAllNotifications()
    completionHandler()
  }
  
  private func handleNotification(userInfo: [AnyHashable: Any]) {
    // guard let localNotificationManager = localNotificationManager else { return }
    guard let routineID = userInfo["routineID"] as? String else {
      DispatchQueue.main.async {
        self.localNotificationManager?.selectedRoutineID = ""
        self.localNotificationManager?.navigateToView = true
      }
      return
    }
    
    DispatchQueue.main.async {
      self.localNotificationManager?.selectedRoutineID = routineID
      self.localNotificationManager?.navigateToView = true
    }
  }
  
  
  func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
