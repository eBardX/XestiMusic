// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCKeySignature {

    // MARK: Public Nested Types

    public typealias Accidental = ABCPitch

    // MARK: Public Initializers

    public init(tonic: Tonic,
                mode: Mode,
                accidentals: [Accidental]) {
        self.accidentals = accidentals
        self.mode = mode
        self.tonic = tonic
    }

    // MARK: Public Instance Properties

    public let accidentals: [Accidental]
    public let mode: Mode
    public let tonic: Tonic
}

// MARK: - Sendable

extension ABCKeySignature: Sendable {
}
