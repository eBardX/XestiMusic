// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension DKMFormatter {
    public enum Error {
        case stringConversionFailed
    }
}

// MARK: - EnhancedError

extension DKMFormatter.Error: EnhancedError {
    public var category: Category? {
        Category("DKMFormatter")
    }

    public var message: String {
        switch self {
        case .stringConversionFailed:
            "Failed to convert string to UTF-8 data"
        }
    }
}

// MARK: - Sendable

extension DKMFormatter.Error: Sendable {
}
