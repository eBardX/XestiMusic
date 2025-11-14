// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLRootFile {

    // MARK: Public Type Properties

    public static let compressedMediaType      = "application/vnd.recordare.musicxml"
    public static let defaultMediaType         = uncompressedMediaType
    public static let oldCompressedMediaType   = "application/musicxml+zip"
    public static let oldUncompressedMediaType = "application/musicxml+xml"
    public static let uncompressedMediaType    = "application/vnd.recordare.musicxml+xml"

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
