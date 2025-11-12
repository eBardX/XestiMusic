// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiGMN
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpGuido(_ fileURL: URL) throws {
        var banner = "Dump of Guido Score File "

        banner += format(fileURL.path)

        emit()
        emit(banner)

        let score = try GMNParser().parse(readFile(fileURL))

        _dump(2, score)

        emit()
    }

    // MARK: Private Instance Methods

    private func _dump(_ indent: Int,
                       _ chord: GMNChord) {
        let segments = chord.segments

        var line = "Chord"

        line += spacer()
        line += format(segments.count, "segment")

        emit(indent, line)

        for (index, segment) in segments.enumerated() {
            _dump(indent + 2, segment, index)
        }
    }

    private func _dump(_ indent: Int,
                       _ note: GMNNote) {
        var line = "Note"

        line += spacer()
        line += _format(note.pitch)
        line += spacer()
        line += _format(note.duration)

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ parameter: GMNTag.Parameter,
                       _ index: Int) {
        var line = "Parameter #"

        line += format(index + 1)
        line += spacer()

        if let name = parameter.name {
            line += name
        } else {
            line += "(omitted)"
        }

        line += spacer()

        switch parameter {
        case let .floating(_, value, unit):
            line += format(value)

            if let unit {
                line += spacer()
                line += unit.rawValue
            }

        case let .integer(_, value, unit):
            line += format(value)

            if let unit {
                line += spacer()
                line += unit.rawValue
            }

        case let .parameter(_, value):
            line += value

        case let .string(_, value):
            line += format(value)

        case let .variable(_, value):
            line += value
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ rest: GMNRest) {
        var line = "Rest"

        line += spacer()
        line += _format(rest.duration)

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ score: GMNScore) {
        let variables = score.variables
        let voices = score.voices

        var header = "Score"

        if !variables.isEmpty {
            header += spacer()
            header += format(variables.count, "variable")
        }

        if !voices.isEmpty {
            header += spacer()
            header += format(voices.count, "voice")
        }

        emit()
        emit(indent, header)

        if !variables.isEmpty {
            emit()

            for (index, variable) in variables.enumerated() {
                _dump(indent + 2, variable, index)
            }
        }

        for (index, voice) in voices.enumerated() {
            _dump(indent + 2, voice, index)
        }
    }

    private func _dump(_ indent: Int,
                       _ segment: GMNChord.Segment,
                       _ index: Int) {
        let symbols = segment.symbols

        var line = "Segment #"

        line += format(index + 1)
        line += spacer()
        line += format(symbols.count, "symbol")

        emit(indent, line)

        for symbol in symbols {
            _dump(indent + 2, symbol)
        }
    }

    private func _dump(_ indent: Int,
                       _ symbol: GMNSymbol) {
        switch symbol {
        case let .chord(chord):
            _dump(indent, chord)

        case let .note(note):
            _dump(indent, note)

        case let .rest(rest):
            _dump(indent, rest)

        case let .tablature(tablature):
            _dump(indent, tablature)

        case let .tag(tag):
            _dump(indent, tag)

        case let .variable(name):
            var line = ""

            line += "Variable"
            line += spacer()
            line += format(name)

            emit(indent, line)
        }
    }

    private func _dump(_ indent: Int,
                       _ tablature: GMNTablature) {
        var line = "Tablature"

        line += spacer()
        line += _format(tablature)
        line += spacer()
        line += _format(tablature.duration)

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ tag: GMNTag) {
        let parameters = tag.parameters
        let symbols = tag.symbols

        var line = "Tag"

        line += spacer()
        line += tag.name

        if let ident = tag.ident {
            line += spacer()
            line += format(ident)
        }

        if !parameters.isEmpty {
            line += spacer()
            line += format(parameters.count, "parameter")
        }

        if !symbols.isEmpty {
            line += spacer()
            line += format(symbols.count, "symbol")
        }

        emit(indent, line)

        for (index, parameter) in parameters.enumerated() {
            _dump(indent + 2, parameter, index)
        }

        for symbol in symbols {
            _dump(indent + 2, symbol)
        }
    }

    private func _dump(_ indent: Int,
                       _ variable: GMNVariable,
                       _ index: Int) {
        var line = "Variable #"

        line += format(index + 1)
        line += spacer()
        line += variable.name
        line += spacer()

        switch variable.value {
        case let .floating(value):
            line += format(value)

        case let .integer(value):
            line += format(value)

        case let .string(value):
            line += format(value)
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ voice: GMNVoice,
                       _ index: Int) {
        let symbols = voice.symbols

        var header = "Voice #"

        header += format(index + 1)
        header += spacer()
        header += format(symbols.count, "symbol")

        emit()
        emit(indent, header)

        if !symbols.isEmpty {
            emit()

            for symbol in symbols {
                _dump(indent + 2, symbol)
            }
        }
    }

    private func _format(_ duration: GMNDuration) -> String {
        var result = ""

        switch duration {
        case let .fraction(numerator, denominator):
            result += format(numerator)
            result += "/"
            result += format(denominator)

        case let .fractionDots(numerator, denominator, dots):
            result += format(numerator)
            result += "/"
            result += format(denominator)
            result += spacer()
            result += format(dots, "dot")

        case let .milliseconds(msecs):
            result += format(msecs)
            result += "ms"
        }

        return result
    }

    private func _format(_ pitch: GMNPitch) -> String {
        var result = pitch.name.rawValue

        result += spacer()

        if let accidental = pitch.accidental {
            result += accidental.rawValue
        } else {
            result += "(none)"
        }

        result += spacer()
        result += format(pitch.octave)

        return result
    }

    private func _format(_ tablature: GMNTablature) -> String {
        var result = format(tablature.tabString)

        result += spacer()
        result += tablature.fret

        return result
    }
}
