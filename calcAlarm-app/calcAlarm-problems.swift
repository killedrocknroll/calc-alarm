import Foundation

struct Problem {
    let prompt: String
    let answer: Int
}

enum ProblemGenerator {

    /// Three different problem types, shuffled, so you never get the same kind twice.
    static func makeSet(count: Int = 3) -> [Problem] {
        let makers: [() -> Problem] = [
            polynomialDerivative,
            productRule,
            chainRule,
            definiteIntegral,
            factoredLimit
        ].shuffled()
        return makers.prefix(count).map { $0() }
    }

    // MARK: - Problem types (all have whole-number answers)

    /// f(x) = ax³ + bx² + cx, find f′(k)
    static func polynomialDerivative() -> Problem {
        let a = Int.random(in: 2...5)
        let b = nonZero(-6...6)
        let c = nonZero(-5...5)
        let k = Int.random(in: -2...3)
        let answer = 3 * a * k * k + 2 * b * k + c
        return Problem(
            prompt: "f(x) = \(a)x³ \(sign(b))x² \(sign(c))x\n\nFind f′(\(k)).",
            answer: answer
        )
    }

    /// f(x) = (x² + a)(bx + c), find f′(k)  [product rule]
    static func productRule() -> Problem {
        let a = nonZero(-4...5)
        let b = Int.random(in: 2...4)
        let c = nonZero(-5...5)
        let k = Int.random(in: -2...3)
        let answer = 2 * k * (b * k + c) + b * (k * k + a)
        return Problem(
            prompt: "f(x) = (x² \(sign(a)))(\(b)x \(sign(c)))\n\nFind f′(\(k)).",
            answer: answer
        )
    }

    /// f(x) = (ax + b)ⁿ, find f′(k)  [chain rule]
    static func chainRule() -> Problem {
        let n = Int.random(in: 3...4)
        let a = Int.random(in: 2...3)
        let b = nonZero(-3...3)
        let k = Int.random(in: 0...2)
        var inner = 1
        for _ in 0..<(n - 1) { inner *= (a * k + b) }
        let answer = n * a * inner
        return Problem(
            prompt: "f(x) = (\(a)x \(sign(b)))\(sup(n))\n\nFind f′(\(k)).",
            answer: answer
        )
    }

    /// ∫ from 0 to k of (ax² + bx) dx, with a a multiple of 3 and b even
    static func definiteIntegral() -> Problem {
        let m = Int.random(in: 1...3)
        let p = Int.random(in: 1...4)
        let k = Int.random(in: 1...3)
        let a = 3 * m
        let b = 2 * p
        let answer = m * k * k * k + p * k * k
        return Problem(
            prompt: "Evaluate the definite integral from 0 to \(k) of (\(a)x² + \(b)x) dx.",
            answer: answer
        )
    }

    /// lim x→c of (xⁿ − cⁿ)/(x − c), n = 2 or 3
    static func factoredLimit() -> Problem {
        let c = Int.random(in: 2...6)
        if Bool.random() {
            return Problem(
                prompt: "Evaluate the limit as x → \(c) of (x² − \(c * c)) / (x − \(c)).",
                answer: 2 * c
            )
        } else {
            return Problem(
                prompt: "Evaluate the limit as x → \(c) of (x³ − \(c * c * c)) / (x − \(c)).",
                answer: 3 * c * c
            )
        }
    }

    // MARK: - Helpers

    private static func nonZero(_ range: ClosedRange<Int>) -> Int {
        var n = 0
        while n == 0 { n = Int.random(in: range) }
        return n
    }

    private static func sign(_ n: Int) -> String {
        n < 0 ? "− \(-n)" : "+ \(n)"
    }

    private static func sup(_ n: Int) -> String {
        ["⁰", "¹", "²", "³", "⁴", "⁵"][n]
    }
}
