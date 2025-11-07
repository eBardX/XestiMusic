// © 2025 John Gary Pusey (see LICENSE.md)

public struct SMFSequence {

    // MARK: Public Initializers

    public init(format: SMFFormat,
                division: SMFDivision,
                tracks: [SMFTrack]) {
        self.division = division
        self.format = format
        self.tracks = tracks
    }

    // MARK: Public Instance Properties

    public let division: SMFDivision
    public let format: SMFFormat
    public let tracks: [SMFTrack]
}

// MARK: - Codable

extension SMFSequence: Codable {
}

// MARK: - Sendable

extension SMFSequence: Sendable {
}
