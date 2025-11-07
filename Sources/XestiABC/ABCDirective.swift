// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCDirective {

    // MARK: Public Type Methods

    public static func canParse(_ value: String) -> Bool {
        value.hasPrefix(expectedPrefix)
    }

    public static func parse(_ value: String) throws -> Self {
        guard value.hasPrefix(expectedPrefix)
        else { throw ABCParser.Error.invalidDirective(value) }

        let tokens = value.dropFirst(expectedPrefix.count).split(separator: " ",
                                                                 maxSplits: 1,
                                                                 omittingEmptySubsequences: false)

        guard tokens.count == 2,
              !tokens[0].isEmpty
        else { throw ABCParser.Error.invalidDirective(value) }

        let name = String(tokens[0])

        guard let head = name.first,
              head.isABCDirectiveNameHead,
              name.dropFirst().allSatisfy({ $0.isABCDirectiveNameTail })
        else { throw ABCParser.Error.invalidDirective(value) }

        return Self(name,
                    String(tokens[1]).normalizedABCWhitespace())
    }

    // MARK: Public Instance Properties

    public let name: String
    public let value: String

    // MARK: Private Type Properties

    private static let expectedPrefix = "%%"

    // MARK: Private Initializers

    private init(_ name: String,
                 _ value: String) {
        self.name = name
        self.value = value
    }
}

// MARK: - Sendable

extension ABCDirective: Sendable {
}
