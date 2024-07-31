//
//  Dynamic.swift
//  Dynamic
//
//  Created by Pil_Gaaang on 7/31/24.
//

import ActivityKit
import SwiftUI

struct DynamicAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var remainingTime: TimeInterval
        var iconName: String  // 아이콘 이름 추가
    }

    var name: String
}

