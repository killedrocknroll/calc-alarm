import AlarmKit

// Add this file to BOTH the app target and the widget extension target.
// If Xcode complains about actor isolation, keep the `nonisolated`.
nonisolated struct MathAlarmMetadata: AlarmMetadata {}
