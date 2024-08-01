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
  
  @EnvironmentObject var localNotificationManager: LocalNotificationManager
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Notification Center delegate setting
    UNUserNotificationCenter.current().delegate = self
    return true
  }
  
  // 알림 눌렀을 때 호출되는 메소드
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    DispatchQueue.main.async {
      let notificationManager = NotificationCenter.default.publisher(for: NSNotification.Name("NotificationManagerUpdate"))
      NotificationCenter.default.post(name: NSNotification.Name("NotificationManagerUpdate"), object: nil, userInfo: ["showTimerView": true])
    }
    cancelAllNotifications()
    completionHandler()
  }
  
  func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
