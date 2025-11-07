// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLOpus {

    // MARK: Public Initializers

    public init(title: String,
                items: [Self.Item]) {
        self.items = items
        self.title = title
    }

    // MARK: Public Instance Properties

    public let items: [Self.Item]
    public let title: String
}

// MARK: - Codable

extension MXLOpus: Codable {
}

// MARK: - Sendable

extension MXLOpus: Sendable {
}
