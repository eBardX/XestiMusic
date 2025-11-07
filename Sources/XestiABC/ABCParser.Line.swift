// © 2025 John Gary Pusey (see LICENSE.md)

extension ABCParser {
    public enum Line {
        case directive(ABCDirective)
        case empty
        case field(ABCField)
        case fileID(ABCFileID)
        case symbols([ABCSymbol])
    }
}

// MARK: - CustomStringConvertible

extension ABCParser.Line: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .directive(directive):
            "Directive: \(directive)"

        case .empty:
            "=== (empty) ==="

        case let .field(field):
            "Field: \(field)"

        case let .fileID(fileID):
            "FileID: \(fileID)"

        case let .symbols(symbols):
            "Symbols: \(symbols)"
        }
    }
}

// MARK: - Sendable

extension ABCParser.Line: Sendable {
}
