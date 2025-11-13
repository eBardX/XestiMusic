// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPitch {

    // MARK: Public Initializers

    public init(step: Step,
                alter: Float,
                octave: Int) {
        self.alter = alter
        self.octave = octave
        self.step = step
    }

    // MARK: Public Instance Properties

    public let alter: Float
    public let octave: Int
    public let step: Step
}

// MARK: - Sendable

extension MXLPitch: Sendable {
}
