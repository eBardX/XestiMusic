// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiText

extension XestiText.Formatter {

    // MARK: Public Type Properties

    public static let defaultPrecision = 3

    // MARK: Public Type Methods

    public static func format(_ value: Double,
                              precision: Int = defaultPrecision,
                              trimTrailingZeros: Bool = true) -> String {
        let formatStyle = doubleFormatStyle.precision(.fractionLength(precision))

        var result = formatStyle.format(value)

        if precision > 0 && trimTrailingZeros {
            var hiIdx = result.endIndex
            var loIdx = result.index(before: hiIdx)

            while result[loIdx] == "0" {
                result.replaceSubrange(loIdx..<hiIdx,
                                       with: "")

                hiIdx = loIdx
                loIdx = result.index(before: hiIdx)
            }
        }

        return result
    }

    public static func format(_ value: Int) -> String {
        intFormatStyle.format(value)
    }

    public static func format(_ value: String,
                              quoteAndEscape: Bool = true) -> String {
        guard quoteAndEscape
        else { return value }

        var result = "\""

        for chr in value {
            result += _formatCharacter(chr)
        }

        result += "\""

        return result
    }

    public static func format(_ value: UInt) -> String {
        uintFormatStyle.format(value)
    }

    // MARK: Private Type Properties

    private static let doubleFormatStyle = FloatingPointFormatStyle<Double>().grouping(.automatic)
    private static let intFormatStyle = IntegerFormatStyle<Int>().grouping(.automatic)
    private static let uintFormatStyle = IntegerFormatStyle<UInt>().grouping(.automatic)

    // MARK: Private Type Methods

    private static func _escape(_ value: Character) -> String {
        switch value {
        case "\u{00}":
            "\\0"

        case "\u{09}":
            "\\t"

        case "\u{0a}":
            "\\n"

        case "\u{0d}":
            "\\r"

        default:
            value.unicodeScalars.map {
                String(format: "\\u{%1$lx}",
                       $0.value)
            }.joined()
        }
    }

    private static func _formatCharacter(_ value: Character) -> String {
        switch value {
        case "\"":
            "\\\""

        case "\\":
            "\\\\"

        case " "..."~":
            String(value)

        default:
            _escape(value)
        }
    }
}
