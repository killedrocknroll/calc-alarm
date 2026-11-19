import SwiftUI

struct SolveView: View {
    @Bindable private var state = AppState.shared
    @State private var answer = ""
    @State private var showWrong = false
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 24) {
            if let problem = state.currentProblem {
                Text("Problem \(state.currentIndex + 1) of \(state.problems.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(problem.prompt)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("Your answer (a whole number)", text: $answer)
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(.roundedBorder)
                    .focused($focused)
                    .onSubmit(submit)
                    .padding(.horizontal, 40)

                if showWrong {
                    Text("Not quite. Try again.")
                        .foregroundStyle(.red)
                }

                Button("Submit", action: submit)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
        .padding()
        .onAppear { focused = true }
    }

    private func submit() {
        let cleaned = answer
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "−", with: "-")

        guard let value = Int(cleaned),
              let problem = state.currentProblem,
              value == problem.answer else {
            showWrong = true
            return
        }

        showWrong = false
        answer = ""
        state.advance()
    }
}
