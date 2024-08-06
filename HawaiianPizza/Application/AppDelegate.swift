//
//  AppDelegate.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import UIKit
import SwiftUI
import UserNotifications
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Notification Center delegate setting
        UNUserNotificationCenter.current().delegate = self
        
        _ = LocationHelper.shared
    
        return true
    }
    
    // 알림 눌렀을 때 호출되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DispatchQueue.main.async {
            let notificationManager = NotificationCenter.default.publisher(for: NSNotification.Name("NotificationManagerUpdate"))
            NotificationCenter.default.post(name: NSNotification.Name("NotificationManagerUpdate"), object: nil, userInfo: ["showTenSecView": true])
        }
        cancelAllNotifications()
        completionHandler()
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
