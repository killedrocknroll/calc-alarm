import SwiftUI

struct ContentView: View {
    @Bindable private var state = AppState.shared
    @State private var wakeTime = Calendar.current.date(
        bySettingHour: 6, minute: 0, second: 0, of: Date()
    ) ?? Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker("Wake time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                Button("Arm alarm") {
                    Task { await state.arm(at: nextOccurrence(of: wakeTime)) }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Test: ring in 1 minute") {
                    Task { await state.arm(at: Date().addingTimeInterval(60), backups: 2) }
                }

                if state.isArmed {
                    Button("Solve now to cancel alarms") { state.startSolving() }
                }

                Text(state.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Math Alarm")
        }
        .fullScreenCover(isPresented: $state.isSolving) {
            SolveView()
        }
    }

    /// Next time the clock hits this hour:minute (today or tomorrow).
    private func nextOccurrence(of time: Date) -> Date {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: time)
        return Calendar.current.nextDate(
            after: Date(), matching: parts, matchingPolicy: .nextTime
        ) ?? time
    }
}
