// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLRootFile {

    public static let defaultMediaType = "application/vnd.recordare.musicxml+xml"

    // MARK: Public Initializers

    public init(fullPath: String,
                mediaType: String) {
        self.fullPath = fullPath
        self.mediaType = mediaType
    }

    // MARK: Public Instance Properties

    public let fullPath: String
    public let mediaType: String
}

// MARK: - Sendable

extension MXLRootFile: Sendable {
}
