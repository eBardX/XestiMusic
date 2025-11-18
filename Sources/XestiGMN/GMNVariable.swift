// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNVariable {

    // MARK: Public Initializers

    public init(name: String,
                value: Value) {
        self.name = name
        self.value = value
    }

    // MARK: Public Instance Properties

    public let name: String
    public let value: Value
}

// MARK: - Sendable

extension GMNVariable: Sendable {
}
