//
//  HapticHelper.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 8/2/24.
//

import UIKit

class HapticHelper {
    static func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
