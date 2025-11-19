// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCRefNumber {

    // MARK: Public Initializers

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt

    // MARK: Internal Type Methods

    internal static func parse(_ value: String) throws -> Self {
        guard let uintValue = UInt(value),
              uintValue > 0
        else { throw ABCParser.Error.invalidRefNumber(value) }

        return Self(rawValue: uintValue)
    }
}

// MARK: - Sendable

extension ABCRefNumber: Sendable {
}
