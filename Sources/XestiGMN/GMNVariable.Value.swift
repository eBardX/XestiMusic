// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNVariable {
    public enum Value {
        case floating(Double)
        case integer(Int)
        case string(String)
    }
}

// MARK: - Sendable

extension GMNVariable.Value: Sendable {
}
