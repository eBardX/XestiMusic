// © 2025 John Gary Pusey (see LICENSE.md)

public enum GMNDuration {
    case dots(UInt)                     // dots: 1...3
    case fraction(UInt, UInt)           // numerator: >0, denominator: >0
    case fractionDots(UInt, UInt, UInt) // numerator: >0, denominator: >0, dots: 1...3
    case milliseconds(UInt)             // milliseconds: >0
}

// MARK: -

extension GMNDuration {

    // MARK: Public Type Properties

    public static let `default`: Self = .fraction(1, 4)

    // MARK: Public Initializers

    public init?(_ text: Substring) {
        guard let value = Self._parseText(text)
        else { return nil }

        self = value
    }

    // MARK: Private Type Methods

    private static func _parseDotsText(_ dtext: Substring?) -> UInt? {
        guard let dtext
        else { return 0 }   // no dots, success

        switch dtext {
        case ".":
            return 1

        case "..":
            return 2

        case "...":
            return 3

        default:
            return nil      // bad dots, failure
        }
    }

    private static func _parseFractionText(_ ntext: Substring?,
                                           _ dtext: Substring?) -> (UInt, UInt)? {
        var numerator: UInt = 1

        if let ntext {
            guard let nvalue = UInt(ntext)
            else { return nil }

            numerator = nvalue
        }

        var denominator: UInt = 1

        if let dtext {
            guard let dvalue = UInt(dtext)
            else { return nil }

            denominator = dvalue
        }

        return (numerator, denominator)
    }

    private static func _parseMillisecondsText(_ mtext: Substring?) -> UInt? {
        guard let mtext
        else { return nil }

        return UInt(mtext)
    }

    private static func _parseText(_ text: Substring) -> Self? {
        //
        // One of:
        //
        //  *<numerator>
        //  *<numerator><dots>
        //  *<numerator>/<denominator>
        //  *<numerator>/<denominator><dots>
        //  *<numerator>ms
        //
        if text.hasPrefix("*") {
            let stext = text.dropFirst()

            if stext.hasSuffix("ms") {
                guard let ms = _parseMillisecondsText(stext.dropLast(2))
                else { return nil }

                return .milliseconds(ms)
            }

            let result1 = stext.splitBeforeFirst(".")
            let result2 = result1.head.splitBeforeFirst("/")

            guard let (numer, denom) = _parseFractionText(result2.head,
                                                          result2.tail?.dropFirst()),
                  let dots = _parseDotsText(result1.tail)
            else { return nil }

            if dots > 0 {
                return .fractionDots(numer, denom, dots)
            }

            return .fraction(numer, denom)
        }

        //
        // One of:
        //
        //  /<denominator>
        //  /<denominator><dots>
        //
        //
        if text.hasPrefix("/") {
            let result = text.dropFirst().splitBeforeFirst(".")

            guard let (numer, denom) = _parseFractionText(nil, result.head),
                  let dots = _parseDotsText(result.tail)
            else { return nil }

            if dots > 0 {
                return .fractionDots(numer, denom, dots)
            }

            return .fraction(numer, denom)
         }

        //
        // <dots>
        //
        guard let dots = _parseDotsText(text),
              dots > 0
        else { return nil }

        return .dots(dots)
    }
}

// MARK: - Sendable

extension GMNDuration: Sendable {
}
