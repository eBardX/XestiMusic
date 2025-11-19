// © 2025 John Gary Pusey (see LICENSE.md)

public enum ABCHeader {
    case directive(ABCDirective)
    case field(ABCField)
}

// MARK: - Sendable

extension ABCHeader: Sendable {
}
