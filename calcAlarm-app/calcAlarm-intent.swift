import AppIntents
import AlarmKit

// Runs when you tap "Solve" on the ringing alarm. Add to the APP target only.
struct OpenSolveIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Solve problems"
    static let openAppWhenRun: Bool = true

    init() {}

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppState.shared.startSolving()
        }
        return .result()
    }
}
