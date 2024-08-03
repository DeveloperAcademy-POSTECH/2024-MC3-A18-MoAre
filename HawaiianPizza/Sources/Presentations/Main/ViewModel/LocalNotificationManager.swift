//
//  LocalNotificationManager.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/30/24.
//

import UserNotifications

struct Noti {
  var id: String
  var title: String
}

class LocalNotificationManager: ObservableObject {
  @Published var navigateToView: Bool = false
  var notifications = [Noti]()
  
  init() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name("NotificationManagerUpdate"), object: nil, queue: .main) { [weak self] notification in
      if let showTimerView = notification.userInfo?["showTimerView"] as? Bool {
        self?.navigateToView = showTimerView
      }
    }
  }
  
  func requestPermission() -> Void {
    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted == true && error == nil {
          print("Permission complete")
        }
      }
  }
  
  func addNotification(title: String) -> Void {
    notifications.append(Noti(id: UUID().uuidString, title: title))
  }
  
  func scheduleNotifications(startingAt startDate: Date, interval: TimeInterval, count: Int) -> Void {
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "오늘의 루틴"
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.caf"))
    // 알람 사운드 예시 파일 넣어뒀어용 여기서 바꾸면 됩니다!
    content.subtitle = "이제 일어나야 해요 🔥"
    content.body = "알림을 누르고 오늘의 루틴을 시작해 보세요!"
    
    for i in 0..<count {
      let triggerDate = startDate.addingTimeInterval(interval * Double(i))
      let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
      let request = UNNotificationRequest(identifier: "reminder_\(i)", content: content, trigger: trigger)
      
      center.add(request) { error in
        if let error = error {
          print("Error scheduling notification: \(error.localizedDescription)")
        } else {
          print("Scheduled notification at \(triggerDate)")
        }
      }
    }
  }
  
  func removeAllPendingNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    print("알림이 모두 지워졌습니다.")
  }
  
  // MARK: - 나중에 알람 말고 새로운 알림을 만들 때 사용할 듯 (특정 알림 삭제)
  func removeNotification(identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
  }
}
