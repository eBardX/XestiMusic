// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTimeSignature {

    // MARK: Public Initializers

    public init(numerator: UInt,
                denominator: UInt) {
        self.denominator = denominator
        self.numerator = numerator
    }

    // MARK: Public Instance Properties

    public let denominator: UInt
    public let numerator: UInt
}

// MARK: - Sendable

extension ABCTimeSignature: Sendable {
}
