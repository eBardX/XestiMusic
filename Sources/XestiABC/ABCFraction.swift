// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCFraction {

    // MARK: Public Initializers

    public init(_ numerator: UInt,
                _ denominator: UInt) {
        self.denominator = denominator
        self.numerator = numerator
    }

    public init?(_ value: String) {
        let tokens = value.split(separator: "/",
                                 maxSplits: 1,
                                 omittingEmptySubsequences: false)

        guard tokens.count == 2,
              !tokens[0].isEmpty,
              !tokens[1].isEmpty,
              let numerator = UInt(tokens[0]),
              let denominator = UInt(tokens[1])
        else { return nil }

        self.init(numerator,
                  denominator)
    }

    // MARK: Public Instance Properties

    public let denominator: UInt
    public let numerator: UInt
}

// MARK: - Sendable

extension ABCFraction: Sendable {
}
