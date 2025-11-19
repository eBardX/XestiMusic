// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTempo {

    // MARK: Public Initializers

    public init(duration: ABCFraction,
                rate: UInt) {
        self.duration = duration
        self.rate = rate
    }

    // MARK: Public Instance Properties

    public let duration: ABCFraction
    public let rate: UInt            // bpm
}

// MARK: - Sendable

extension ABCTempo: Sendable {
}
