// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension MXLParser {
    public enum Error {
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
        }
    }

    public var message: String {
        switch self {
        case .parseFailure:
            "Unable to parse MusicXML file"
        }
    }
}

// MARK: - Sendable

extension MXLParser.Error: Sendable {
}
