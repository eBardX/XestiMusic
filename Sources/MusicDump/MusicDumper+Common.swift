// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
// import XestiText

extension MusicDumper {

    // MARK: Internal Type Methods

    internal func emit(_ indent: Int,
                       _ line: String) {
        if indent > 0 && !line.isEmpty {
            emit(" ".repeating(to: indent) + line)
        } else {
            emit(line)
        }
    }

    internal func format<R>(_ value: Double,
                            precision: R = 0...3) -> String where R: RangeExpression,
                                                                  R.Bound == Int {
        let formatStyle = Self.doubleFormatStyle.precision(.fractionLength(precision))

        return formatStyle.format(value)
    }

    internal func format<R>(_ value: Float,
                            precision: R = 0...3) -> String where R: RangeExpression,
                                                                  R.Bound == Int {
        let formatStyle = Self.floatFormatStyle.precision(.fractionLength(precision))

        return formatStyle.format(value)
    }

    internal func format(_ value: Int) -> String {
        Self.intFormatStyle.format(value)
    }

    internal func format(_ value: Int,
                         _ units: String,
                         plural: String? = nil) -> String {
        var result = format(value)

        result += " "
        result += value != 1 ? (plural ?? units + "s") : units

        return result
    }

    internal func format(_ value: String) -> String {
        var result = "\""

        for chr in value {
            result += Self._formatCharacter(chr)
        }

        result += "\""

        return result
    }

    internal func format(_ value: UInt) -> String {
        Self.uintFormatStyle.format(value)
    }

    internal func readFile(_ fileURL: URL) throws -> Data {
        let file = try FileWrapper(url: fileURL,
                                   options: .immediate)

        return try file.contentsOfRegularFile()
    }

    internal func format(_ value: UInt,
                         _ units: String,
                         plural: String? = nil) -> String {
        var result = format(value)

        result += " "
        result += value != 1 ? (plural ?? units + "s") : units

        return result
    }

    internal func spacer() -> String {
        " ∙ "
    }

    internal func unzipArchive(_ fileURL: URL) throws -> FileWrapper {
        let file = try FileWrapper(url: fileURL,
                                   options: .immediate)

        return try file.unzip()
    }

    // MARK: Private Type Properties

    private static let doubleFormatStyle = FloatingPointFormatStyle<Double>().grouping(.automatic)
    private static let floatFormatStyle = FloatingPointFormatStyle<Float>().grouping(.automatic)
    private static let intFormatStyle = IntegerFormatStyle<Int>().grouping(.automatic)
    private static let uintFormatStyle = IntegerFormatStyle<UInt>().grouping(.automatic)

    // MARK: Private Type Methods

    private static func _formatCharacter(_ value: Character) -> String {
        switch value {
        case "\u{00}":
            "\\0"

        case "\u{09}":
            "\\t"

        case "\u{0a}":
            "\\n"

        case "\u{0d}":
            "\\r"

        case "\"":
            "\\\""

        case "\\":
            "\\\\"

        default:
            String(value)
        }
    }
}
