// © 2025 John Gary Pusey (see LICENSE.md)

public enum GMNSymbol {
    case chord(GMNChord)
    case note(GMNNote)
    case rest(GMNRest)
    case tablature(GMNTablature)
    case tag(GMNTag)
    case variable(String)
}

// MARK: -

extension GMNSymbol {

    // MARK: Public Instance Properties

    public var isMusic: Bool {
        switch self {
        case .chord, .note, .rest, .tablature:
            true

        case let .tag(tag):
            tag.symbols.contains { $0.isMusic }

        default:
            false
        }
    }

    public var tagValue: GMNTag? {
        switch self {
        case let .tag(tag):
            tag

        default:
            nil
        }
    }
}

// MARK: - Sendable

extension GMNSymbol: Sendable {
}
