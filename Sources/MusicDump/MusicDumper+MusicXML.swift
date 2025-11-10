// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiMXL
import XestiText

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpMusicXML(_ fileURL: URL) throws {
        emit()
        emit("Dump of MusicXML Document “\(fileURL.path)”")

        if fileURL.pathExtension != "mxl" {
            let entity = try MXLParser(readFile(fileURL)).parse()

            _dump(entity)
        } else {
            fatalError("Not yet implemented")
        }

        emit()
    }

    // MARK: Private Type Properties

    // MARK: Private Instance Methods

    private func _dump(_ entity: MXLEntity) {
        switch entity {
        case let .scorePartwise(score):
            _dump(score)

        default:
            fatalError("Not yet implemented")
        }
    }

    private func _dump(_ item: MXLMusicItem) {
        var line = ""

        switch item {
        case let .attributes(divisions):
            line += "Divisions ∙ "

            if let divisions {
                line += Formatter.format(divisions)
            } else {
                line += "Unknown"
            }

        case let .backup(duration):
            line += "Backup ∙ "
            line += Formatter.format(duration)

        case let .forward(duration):
            line += "Forward ∙ "
            line += Formatter.format(duration)

        case let .note(note):
            line += _format(note)

        case let .sound(tempo):
            line += "Tempo ∙ "

            if let tempo {
                line += Formatter.format(Int(tempo))
                line += "bpm"
            } else {
                line += "Unknown"
            }
        }

        emit(8, line)
    }

    private func _dump(_ measure: MXLMeasurePartwise) {
        let items = measure.items
        let itemCount = items.count

        var header = "Measure "

        header += Formatter.format(measure.number,
                                   quoteAndEscape: false)
        header += " ∙ "
        header += Formatter.format(itemCount)
        header += " "
        header += itemCount != 1 ? "items" : "item"

        emit()
        emit(6, header)

        if !items.isEmpty {
            emit()

            for item in items {
                _dump(item)
            }
        }
    }

    private func _dump(_ movementNumber: String?,
                       _ movementTitle: String?) {
        var line = "Movement"

        if let movementNumber {
            line += " ∙ "
            line += Formatter.format(movementNumber)
        }

        if let movementTitle {
            line += " ∙ "
            line += Formatter.format(movementTitle)
        }

        emit()
        emit(4, line)
    }

    private func _dump(_ partList: MXLPartList) {
        let partCount = partList.scoreParts.count

        var header = "Part-list ∙ "

        header += Formatter.format(partCount)
        header += " "
        header += partCount != 1 ? "score-parts" : "score-part"

        emit()
        emit(4, header)
        emit()

        for scorePart in partList.scoreParts {
            _dump(scorePart)
        }
    }

    private func _dump(_ part: MXLPartPartwise) {
        let measureCount = part.measures.count

        var header = "Part "

        header += Formatter.format(part.id)
        header += " ∙ "
        header += Formatter.format(measureCount)
        header += " "
        header += measureCount != 1 ? "measures" : "measure"

        emit()
        emit(4, header)

        for measure in part.measures {
            _dump(measure)
        }
    }

    private func _dump(_ scorePart: MXLScorePart) {
        var line = "Score-part "

        line += Formatter.format(scorePart.id)
        line += " ∙ "
        line += Formatter.format(scorePart.partName)

        emit(6, line)
    }

    private func _dump(_ score: MXLScorePartwise) {
        let partCount = score.parts.count

        var header = "Score ∙ Partwise ∙ "

        header += Formatter.format(partCount)
        header += " "
        header += partCount != 1 ? "parts" : "part"

        emit()
        emit(2, header)

        if let work = score.work {
            _dump(work)
        }

        _dump(score.movementNumber,
              score.movementTitle)

        _dump(score.partList)

        for part in score.parts {
            _dump(part)
        }
    }

    private func _dump(_ work: MXLWork) {
        var line = "Work"

        if let workNumber = work.workNumber {
            line += " ∙ "
            line += Formatter.format(workNumber)
        }

        if let workTitle = work.workTitle {
            line += " ∙ "
            line += Formatter.format(workTitle)
        }

        emit()
        emit(4, line)
    }

    private func _format(_ alter: Float?) -> String? {
        guard let alter
        else { return nil }

        switch Int(alter) {
        case -2:
            return "𝄫"

        case -1:
            return "♭"

        case 1:
            return "♯"

        case 2:
            return "𝄪"

        default:
            return nil
        }
    }

    private func _format(_ note: MXLNote) -> String {
        var line = ""

        if let chord = note.chord, chord {
            line += "Chord ∙ "
        }

        line += _format(note.value)
        line += " ∙ "
        line += Formatter.format(note.duration)

        if let result = _format(note.tie) {
            line += " ∙ "
            line += result
        }

        return line
    }

    private func _format(_ pitch: MXLPitch) -> String {
        var result = pitch.step

        if let alter = _format(pitch.alter) {
            result += alter
        }

        result += Formatter.format(pitch.octave)

        return result
    }

    private func _format(_ tie: MXLTie) -> String? {
        switch tie {

        case .neither:
            nil

        case .start:
            "Start tie"

        case .stop:
            "Stop tie"

        case .stopStart:
            "Stop/start tie"
        }
    }

    private func _format(_ value: MXLNote.Value) -> String {
        switch value {
        case let .pitch(pitch):
            "Pitch ∙ " + _format(pitch)

        case .rest:
            "Rest"

        case .unpitched:
            "Unpitched"
        }
    }
}
