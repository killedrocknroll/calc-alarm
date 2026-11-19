import WidgetKit
import SwiftUI
import AlarmKit

// Put this file in the WIDGET EXTENSION target only (delete the other
// files Xcode generated in that extension). MathAlarmMetadata.swift is
// shared with the app target.

@main
struct AlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        AlarmLiveActivity()
    }
}

struct AlarmLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<MathAlarmMetadata>.self) { _ in
            Text("Wake up! Solve 3 problems to turn this off.")
                .padding()
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Wake up!")
                }
            } compactLeading: {
                Image(systemName: "alarm")
            } compactTrailing: {
                EmptyView()
            } minimal: {
                Image(systemName: "alarm")
            }
        }
    }
}
