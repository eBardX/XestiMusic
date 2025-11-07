// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCRefNumber {

    // MARK: Public Type Methods

    public static func parse(_ value: String) throws -> Self {
        guard let uintValue = UInt(value),
              uintValue > 0
        else { throw ABCParser.Error.invalidRefNumber(value) }

        return Self(uintValue)
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt

    // MARK: Private Initializers

    private init(_ rawValue: UInt) {
        self.rawValue = rawValue
    }
}

// MARK: - Sendable

extension ABCRefNumber: Sendable {
}
