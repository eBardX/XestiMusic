// © 2025 John Gary Pusey (see LICENSE.md)

public enum MXLTie {
    case neither
    case start
    case stop
    case stopStart
}

// MARK: -

extension MXLTie {

    // MARK: Public Type Methods

    public static func + (lhs: Self,
                          rhs: Self) -> Self {
        switch (lhs, rhs) {
        case (_, .neither),
            (.start, .start),
            (.stop, .stop),
            (.stopStart, _):
            lhs

        case (_, .stopStart),
            (.neither, _):
            rhs

        case (.start, .stop),
            (.stop, .start):
                .stopStart
        }
    }

    public static func += (lhs: inout Self,
                           rhs: Self) {
        lhs = lhs + rhs
    }

    // MARK: Public Initializers

    public init?(_ value: String) {
        switch value {
        case "start":
            self = .start

        case "stop":
            self = .stop

        default:
            return nil
        }
    }
}

// MARK: - Sendable

extension MXLTie: Sendable {
}
