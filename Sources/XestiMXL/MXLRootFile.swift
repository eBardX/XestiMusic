// © 2025 John Gary Pusey (see LICENSE.md)

public struct MXLRootFile {

    // MARK: Public Initializers

    public init(fullPath: String,
                mediaType: String?) {
        self.fullPath = fullPath
        self.mediaType = mediaType
    }

    // MARK: Public Instance Properties

    public let fullPath: String
    public let mediaType: String?
}

// MARK: - Codable

extension MXLRootFile: Codable {
}

// MARK: - Sendable

extension MXLRootFile: Sendable {
}
