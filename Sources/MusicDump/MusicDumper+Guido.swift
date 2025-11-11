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

        for segment in segments {
            _dump(indent + 2, segment)
        }
    }

    private func _dump(_ indent: Int,
                       _ note: GMNNote) {
        var line = "Note"

        line += spacer()
        line += _format(note.pitch)

        if let duration = note.duration {
            line += spacer()
            line += _format(duration)
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ parameter: GMNTag.Parameter) {
        var line = "Parameter"

        switch parameter {

        case let .floating(name, value, unit):
            if let name {
                line += spacer()
                line += format(name)
            }

            line += spacer()
            line += format(value)

            if let unit {
                line += spacer()
                line += format(unit)
            }

        case let .integer(name, value, unit):
            if let name {
                line += spacer()
                line += format(name)
            }

            line += spacer()
            line += format(value)

            if let unit {
                line += spacer()
                line += format(unit)
            }

        case let .parameter(name, value):
            if let name {
                line += spacer()
                line += format(name)
            }

            line += spacer()
            line += format(value)

        case let .string(name, value):
            if let name {
                line += spacer()
                line += format(name)
            }

            line += spacer()
            line += format(value)

        case let .variable(name, value):
            if let name {
                line += spacer()
                line += format(name)
            }

            line += spacer()
            line += format(value)
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ rest: GMNRest) {
        var line = "Rest"

        if let duration = rest.duration {
            line += spacer()
            line += _format(duration)
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ score: GMNScore) {
        let variables = score.variables
        let voices = score.voices

        var header = "Score"

        header += spacer()
        header += format(variables.count, "variable")
        header += spacer()
        header += format(voices.count, "voice")

        emit()
        emit(indent, header)

        if !variables.isEmpty {
            emit()

            for variable in variables {
                _dump(indent + 2, variable)
            }
        }

        for (index, voice) in voices.enumerated() {
            _dump(indent + 2, voice, index)
        }
    }

    private func _dump(_ indent: Int,
                       _ segment: GMNChord.Segment) {
        let symbols = segment.symbols

        var line = "Segment"

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

        if let duration = tablature.duration {
            line += spacer()
            line += _format(duration)
        }

        emit(indent, line)
    }

    private func _dump(_ indent: Int,
                       _ tag: GMNTag) {
        let parameters = tag.parameters
        let symbols = tag.symbols

        var line = "Tag"

        line += spacer()

        var name = tag.name

        if let ident = tag.ident {
            name += format(ident)
        }

        line += format(name)
        line += spacer()
        line += format(parameters.count, "parameter")
        line += spacer()
        line += format(symbols.count, "symbol")

        emit(indent, line)

        for parameter in parameters {
            _dump(indent + 2, parameter)
        }

        for symbol in symbols {
            _dump(indent + 2, symbol)
        }
    }

    private func _dump(_ indent: Int,
                       _ variable: GMNVariable) {
        var line = "Variable"

        line += spacer()
        line += format(variable.name)
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
        var result = "<"

        switch duration {
        case let .dots(dots):
            result += format(dots, "dot")

        case let .fraction(numerator, denominator):
            result += format(numerator)
            result += "/"
            result += format(denominator)

        case let .fractionDots(numerator, denominator, dots):
            result += format(numerator)
            result += "/"
            result += format(denominator)
            result += ", "
            result += format(dots, "dot")

        case let .milliseconds(msecs):
            result += format(msecs)
            result += "ms"
        }

        result += ">"

        return result
    }

    private func _format(_ pitch: GMNPitch) -> String {
        var result = "<"

        result += format(pitch.name)

        if let accidental = pitch.accidental {
            result += ", "
            result += format(accidental)
        }

        if let octave = pitch.octave {
            result += ", "
            result += format(octave)
        }

        result += ">"

        return result
    }

    private func _format(_ tablature: GMNTablature) -> String {
        var result = "<"

        result += format(tablature.tabString)
        result += ", "
        result += format(tablature.fret)

        result += ">"

        return result
    }
}
