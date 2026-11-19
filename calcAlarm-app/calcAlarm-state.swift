import Foundation
import Observation

@Observable
final class AppState {
    static let shared = AppState()

    var isSolving = false
    var problems: [Problem] = []
    var currentIndex = 0
    var alarmIDs: [UUID] = []
    var statusMessage = ""

    private let storageKey = "armedAlarmIDs"

    private init() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        alarmIDs = saved.compactMap { UUID(uuidString: $0) }
    }

    var isArmed: Bool { !alarmIDs.isEmpty }

    var currentProblem: Problem? {
        problems.indices.contains(currentIndex) ? problems[currentIndex] : nil
    }

    /// Schedules the main alarm plus backups every 2 minutes.
    func arm(at wake: Date, backups: Int = 9) async {
        guard await AlarmScheduler.requestPermission() else {
            statusMessage = "Alarm permission denied. Turn it on in Settings."
            return
        }

        AlarmScheduler.cancel(alarmIDs)

        var ids: [UUID] = []
        var errorText: String?
        for i in 0...backups {
            let time = wake.addingTimeInterval(Double(i) * 120)
            do {
                ids.append(try await AlarmScheduler.schedule(at: time))
            } catch {
                errorText = "Couldn't schedule alarm \(i + 1): \(error.localizedDescription)"
                break
            }
        }

        alarmIDs = ids
        save()

        if let errorText {
            statusMessage = "\(ids.count) scheduled. \(errorText)"
        } else {
            statusMessage = "Armed: \(ids.count) alarms, first at \(wake.formatted(date: .omitted, time: .shortened))"
        }
    }

    func startSolving() {
        guard !isSolving else { return }
        problems = ProblemGenerator.makeSet()
        currentIndex = 0
        isSolving = true
    }

    func advance() {
        currentIndex += 1
        if currentIndex >= problems.count { finish() }
    }

    func finish() {
        AlarmScheduler.cancel(alarmIDs)
        alarmIDs = []
        save()
        isSolving = false
        statusMessage = "All done. Alarm is off. Good morning!"
    }

    private func save() {
        UserDefaults.standard.set(alarmIDs.map(\.uuidString), forKey: storageKey)
    }
}
