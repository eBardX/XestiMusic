// © 2025 John Gary Pusey (see LICENSE.md)

public enum GMNDuration {
    case fraction(UInt, UInt)           // numerator: >0, denominator: >0
    case fractionDots(UInt, UInt, UInt) // numerator: >0, denominator: >0, dots: 1...3
    case milliseconds(UInt)             // milliseconds: >0
}

// MARK: -

extension GMNDuration {

    // MARK: Internal Nested Types

    internal typealias ParseResult = (numerator: UInt?, denominator: UInt?, dots: UInt?)

    // MARK: Internal Type Methods

    internal static func parseText(_ text: Substring) -> ParseResult? {
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

                return (ms, 0, nil)
            }

            let result1 = stext.splitBeforeFirst(".")
            let result2 = result1.head.splitBeforeFirst("/")

            guard let (numer, denom) = _parseFractionText(result2.head,
                                                          result2.tail?.dropFirst()),
                  let dots = _parseDotsText(result1.tail)
            else { return nil }

            if dots > 0 {
                return (numer, denom, dots)
            }

            return (numer, denom, nil)
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
                return (numer, denom, dots)
            }

            return (numer, denom, nil)
        }

        //
        // <dots>
        //
        guard let dots = _parseDotsText(text),
              dots > 0
        else { return nil }

        return (nil, nil, dots)
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
}

// MARK: - Sendable

extension GMNDuration: Sendable {
}
