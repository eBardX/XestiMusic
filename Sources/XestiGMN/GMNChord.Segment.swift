// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNChord {

    // MARK: Public Nested Types

    public struct Segment {

        // MARK: Public Initializers

        public init?(symbols: [GMNSymbol]) {
            guard !Self._containsNestedChord(symbols)
            else { return nil }

            self.symbols = symbols
        }

        // MARK: Public Instance Properties

        public let symbols: [GMNSymbol]
    }
}

// MARK: -

extension GMNChord.Segment {

    // MARK: Private Type Methods

    private static func _containsNestedChord(_ symbols: [GMNSymbol]) -> Bool {
        for symbol in symbols {
            switch symbol {
            case .chord:
                return true

            case let .tag(tag):
                if _containsNestedChord(tag.symbols) {
                    return true
                }

            default:
                break
            }
        }

        return false
    }
}

// MARK: - Sendable

extension GMNChord.Segment: Sendable {
}
