import AlarmKit
import SwiftUI

enum AlarmScheduler {

    static func requestPermission() async -> Bool {
        switch AlarmManager.shared.authorizationState {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            let result = try? await AlarmManager.shared.requestAuthorization()
            return result == .authorized
        @unknown default:
            return false
        }
    }

    /// Schedules one alarm at an exact date and returns its ID.
    static func schedule(at date: Date) async throws -> UUID {
        let id = UUID()

        let stopButton = AlarmButton(
            text: "Stop",
            textColor: .white,
            systemImageName: "stop.fill"
        )
        let solveButton = AlarmButton(
            text: "Solve",
            textColor: .white,
            systemImageName: "function"
        )

        let alert = AlarmPresentation.Alert(
            title: "Wake up! Solve 3 problems",
            stopButton: stopButton,
            secondaryButton: solveButton,
            secondaryButtonBehavior: .custom
        )

        let attributes = AlarmAttributes(
            presentation: AlarmPresentation(alert: alert),
            metadata: MathAlarmMetadata(),
            tintColor: .orange
        )

        let configuration = AlarmManager.AlarmConfiguration.alarm(
            schedule: .fixed(date),
            attributes: attributes,
            secondaryIntent: OpenSolveIntent(),
            sound: .default
        )

        _ = try await AlarmManager.shared.schedule(id: id, configuration: configuration)
        return id
    }

    static func cancel(_ ids: [UUID]) {
        for id in ids {
            try? AlarmManager.shared.stop(id: id)
            try? AlarmManager.shared.cancel(id: id)
        }
    }
}
