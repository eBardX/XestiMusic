// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLPitch {

    // MARK: Public Initializers

    public init(step: String,
                alter: Float?,
                octave: Int) {
        self.alter = alter
        self.octave = octave
        self.step = step
    }

    // MARK: Public Instance Properties

    public let alter: Float?
    public let octave: Int
    public let step: String
}

// MARK: - Codable

extension MXLPitch: Codable {
}

// MARK: - Sendable

extension MXLPitch: Sendable {
}
