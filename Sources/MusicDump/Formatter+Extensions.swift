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

    public static func format(_ value: UInt) -> String {
        uintFormatStyle.format(value)
    }

    // MARK: Private Type Properties

    private static let doubleFormatStyle = FloatingPointFormatStyle<Double>().grouping(.automatic)
    private static let intFormatStyle = IntegerFormatStyle<Int>().grouping(.automatic)
    private static let uintFormatStyle = IntegerFormatStyle<UInt>().grouping(.automatic)
}
