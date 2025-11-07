// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCFileID {

    // MARK: Public Type Methods

    public static func canParse(_ value: String) -> Bool {
        value.hasPrefix(expectedPrefix)
    }

    public static func parse(_ value: String) throws -> Self {
        guard value == expectedValue
        else { throw ABCParser.Error.invalidFileID(value) }

        return Self(expectedSuffix)
    }

    // MARK: Public Instance Properties

    public let version: String

    // MARK: Private Type Properties

    private static let expectedPrefix = "%abc"
    private static let expectedSuffix = "2.1"
    private static let expectedValue  = "\(expectedPrefix)-\(expectedSuffix)"

    // MARK: Private Initializers

    private init(_ version: String) {
        self.version = version
    }
}

// MARK: - Sendable

extension ABCFileID: Sendable {
}
