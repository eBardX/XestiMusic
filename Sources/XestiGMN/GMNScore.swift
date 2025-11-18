// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNScore {

    // MARK: Public Initializers

    public init(variables: [GMNVariable],
                voices: [GMNVoice]) {
        self.variables = variables
        self.voices = voices
    }

    // MARK: Public Instance Properties

    public let variables: [GMNVariable]
    public let voices: [GMNVoice]
}

// MARK: - Sendable

extension GMNScore: Sendable {
}
