// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCTimeSignature {

    // MARK: Public Type Methods

    public static func parse(_ value: String) throws -> Self? {
        switch value {
        case "C":
            return Self(4, 4)

        case "C|":
            return Self(2, 2)

        case "none":
            return nil

        default:
            let tokens = value.split(separator: "/")

            guard tokens.count == 2,
                  let numerator = UInt(tokens[0]),
                  numerator > 0,
                  let denominator = UInt(tokens[1]),
                  [1, 2, 4, 8, 16, 32, 64].contains(denominator)
            else { throw ABCParser.Error.invalidTimeSignature(value) }

            return Self(numerator,
                        denominator)
        }
    }

    // MARK: Public Instance Properties

    public let denominator: UInt
    public let numerator: UInt

    // MARK: Private Initializers

    private init(_ numerator: UInt,
                 _ denominator: UInt) {
        self.denominator = denominator
        self.numerator = numerator
    }
}

// MARK: - Sendable

extension ABCTimeSignature: Sendable {
}
