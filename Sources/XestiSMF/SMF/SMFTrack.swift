// © 2025 John Gary Pusey (see LICENSE.md)

public struct SMFTrack {

    // MARK: Public Instance Properties

    public let events: [SMFEvent]
}

// MARK: - Codable

extension SMFTrack: Codable {
}

// MARK: - Sendable

extension SMFTrack: Sendable {
}
