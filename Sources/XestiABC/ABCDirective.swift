// © 2025 John Gary Pusey (see LICENSE.md)

public struct ABCDirective {

    // MARK: Public Initializers

    public init(name: String,
                value: String?) {
        self.name = name
        self.value = value
    }

    // MARK: Public Instance Properties

    public let name: String
    public let value: String?
}

// MARK: - Sendable

extension ABCDirective: Sendable {
}
