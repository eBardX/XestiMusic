// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension ABCPreprocessor {
    public enum Error {
        case dataConversionFailed
    }
}

// MARK: - EnhancedError

extension ABCPreprocessor.Error: EnhancedError {
    public var category: Category? {
        Category("ABCPreprocessor")
    }

    public var message: String {
        switch self {
        case .dataConversionFailed:
            "Failed to convert UTF-8 data to string"
        }
    }
}

// MARK: - Sendable

extension ABCPreprocessor.Error: Sendable {
}
