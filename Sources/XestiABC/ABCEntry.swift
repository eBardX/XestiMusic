// © 2025 John Gary Pusey (see LICENSE.md)

public enum ABCEntry {
    case directive(ABCDirective)
    case field(ABCField)
    case symbols([ABCSymbol])
}

// MARK: - Sendable

extension ABCEntry: Sendable {
}
