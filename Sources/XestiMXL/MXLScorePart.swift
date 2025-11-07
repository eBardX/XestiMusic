// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLScorePart {

    // MARK: Public Initializers

    public init(id: String,
                partName: String) {
        self.id = id
        self.partName = partName
    }

    // MARK: Public Instance Properties

    public let id: String
    public let partName: String
}

// MARK: - Codable

extension MXLScorePart: Codable {
}

// MARK: - Sendable

extension MXLScorePart: Sendable {
}
