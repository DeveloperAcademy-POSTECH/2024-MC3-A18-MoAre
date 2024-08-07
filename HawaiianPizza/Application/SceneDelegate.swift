//
//  SceneDelegate.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/31/24.
//

import UIKit
import ActivityKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    func sceneDidEnterBackground(_ scene: UIScene) {
        startBackgroundTask()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        endBackgroundTask()
    }

    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyBackgroundTask") {
            // 백그라운드 작업이 시간이 초과되었을 때 실행되는 코드
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }

        DispatchQueue.global().async {
            while UIApplication.shared.backgroundTimeRemaining > 1 {
                // 타이머 작업을 여기에 추가
                sleep(1)
            }

            // 백그라운드 작업이 완료되었을 때 작업을 끝냅니다.
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }

    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
