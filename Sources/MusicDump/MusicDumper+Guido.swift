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

        _dump(score)

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

    private func _dump(_ score: GMNScore) {
        let variables = score.variables
        let voices = score.voices

        var header = "Score"

        header += spacer()
        header += format(variables.count, "variable")
        header += spacer()
        header += format(voices.count, "voice")

        emit()
        emit(2, header)

        if !variables.isEmpty {
            emit()

            for variable in variables {
                _dump(variable)
            }
        }

        for (index, voice) in voices.enumerated() {
            _dump(voice, index)
        }
    }

    private func _dump(_ symbol: GMNSymbol) {
        var line = ""

        switch symbol {
        case .chord:
            line += "Chord ..."

        case let .note(note):
            line += "Note"
            line += spacer()
            line += _format(note)

        case let .rest(rest):
            line += "Rest"
            line += spacer()
            line += _format(rest)

        case let .tablature(tablature):
            line += "Tablature"
            line += spacer()
            line += _format(tablature)

        case .tag:
            line += "Tag ..."

        case let .variable(name):
            line += "Variable"
            line += spacer()
            line += format(name)
        }

        emit(6, line)
    }

    private func _dump(_ variable: GMNVariable) {
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

        emit(4, line)
    }

    private func _dump(_ voice: GMNVoice,
                       _ index: Int) {
        let symbols = voice.symbols

        var header = "Voice #"

        header += format(index + 1)
        header += spacer()
        header += format(symbols.count, "symbol")

        emit()
        emit(4, header)

        if !symbols.isEmpty {
            emit()

            for symbol in symbols {
                _dump(symbol)
            }
        }
    }

    private func _format(_ duration: GMNDuration?) -> String {
        guard let duration
        else { return "(default)" }

        var result = ""

        //
        // Format dots (if any):
        //
        switch duration {
        case let .dots(dots),
            let .fractionDots(_, _, dots):
            switch dots {
            case 1:
                result += "dotted "

            case 2:
                result += "double-dotted "

            case 3:
                result += "triple-dotted "

            default:
                break
            }

        default:
            break
        }

        //
        // Format numerator/denominator or milliseconds:
        //
        switch duration {
        case .dots:
            result += "(default)"

        case let .fraction(numerator, denominator),
            let .fractionDots(numerator, denominator, _):
            result += format(numerator)
            result += "/"
            result += format(denominator)

        case let .milliseconds(msecs):
            result += format(msecs)
            result += "ms"
        }

        return result
    }

    private func _format(_ note: GMNNote) -> String {
        var result = _format(note.pitch)

        result += spacer()
        result += _format(note.duration)

        return result
    }

    private func _format(_ pitch: GMNPitch) -> String {
        var result = ""

        //
        // Format name:
        //
        result += format(pitch.name)

        //
        // Format accidental (if any):
        //
        if let accidental = pitch.accidental {
            result += spacer()
            result += format(accidental)
        }

        //
        // Format octave (if any):
        //
        if let octave = pitch.octave {
            result += spacer()
            result += format(octave)
        }

        return result
    }

    private func _format(_ rest: GMNRest) -> String {
        _format(rest.duration)
    }

    private func _format(_ tablature: GMNTablature) -> String {
        var result = format(tablature.fret)

        result += spacer()
        result += format(tablature.tabString)
        result += spacer()
        result += _format(tablature.duration)

        return result
    }
}
