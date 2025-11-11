// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension MXLParser {
    public enum Error {
        case invalidRootFileMediaType(String)
        case noRootFileFound
        case parseFailure((any EnhancedError)?)
    }
}

// MARK: - EnhancedError

extension MXLParser.Error: EnhancedError {
    public var category: Category? {
        Category("MXLParser")
    }

    public var cause: (any EnhancedError)? {
        switch self {
        case let .parseFailure(error):
            error

        default:
            nil
        }
    }

    public var message: String {
        switch self {
        case let .invalidRootFileMediaType(mediaType):
            "Invalid root file media type: \(mediaType)"

        case .noRootFileFound:
            "No root files found in container"

        case .parseFailure:
            "Unable to parse MusicXML file"
        }
    }
}

// MARK: - Sendable

extension MXLParser.Error: Sendable {
}
