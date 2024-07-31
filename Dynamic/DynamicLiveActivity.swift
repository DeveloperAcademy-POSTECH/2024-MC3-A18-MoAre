//
//  DynamicLiveActivity.swift
//  Dynamic
//
//  Created by Pil_Gaaang on 7/31/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DynamicLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DynamicAttributes {
    fileprivate static var preview: DynamicAttributes {
        DynamicAttributes(name: "World")
    }
}

extension DynamicAttributes.ContentState {
    fileprivate static var smiley: DynamicAttributes.ContentState {
        DynamicAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DynamicAttributes.ContentState {
         DynamicAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DynamicAttributes.preview) {
   DynamicLiveActivity()
} contentStates: {
    DynamicAttributes.ContentState.smiley
    DynamicAttributes.ContentState.starEyes
}
