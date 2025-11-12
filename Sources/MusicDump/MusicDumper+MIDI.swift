// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiSMF
import XestiText

// swiftlint:disable file_length

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func dumpMIDI(_ fileURL: URL) throws {
        var banner = "Dump of Standard MIDI File "

        banner += format(fileURL.path)

        emit()
        emit(banner)

        let sequence = try SMFParser().parse(readFile(fileURL))

        _dump(2, sequence)

        emit()
    }

    // MARK: Private Type Properties

    private static let controllerNames: [UInt: String] = [0: "Bank select MSB",
                                                          1: "Modulation wheel MSB",
                                                          2: "Breath controller MSB",

                                                          4: "Foot controller MSB",
                                                          5: "Portamento time MSB",
                                                          6: "Data entry MSB",
                                                          7: "Channel volume MSB",
                                                          8: "Balance MSB",

                                                          10: "Pan MSB",
                                                          11: "Expression controller MSB",
                                                          12: "Effect control 1 MSB",
                                                          13: "Effect control 2 MSB",

                                                          16: "General purpose controller 1 MSB",
                                                          17: "General purpose controller 2 MSB",
                                                          18: "General purpose controller 3 MSB",
                                                          19: "General purpose controller 4 MSB",

                                                          32: "Bank select LSB",
                                                          33: "Modulation wheel LSB",
                                                          34: "Breath controller LSB",

                                                          36: "Foot controller LSB",
                                                          37: "Portamento time LSB",
                                                          38: "Data entry LSB",
                                                          39: "Channel volume LSB",
                                                          40: "Balance LSB",

                                                          42: "Pan LSB",
                                                          43: "Expression controller LSB",
                                                          44: "Effect control 1 LSB",
                                                          45: "Effect control 2 2LSB",

                                                          48: "General purpose controller 1 LSB",
                                                          49: "General purpose controller 2 LSB",
                                                          50: "General purpose controller 3 LSB",
                                                          51: "General purpose controller 4 LSB",

                                                          64: "Sustain",
                                                          65: "Portamento",
                                                          66: "Sostenuto",
                                                          67: "SoftPedal",
                                                          68: "Legato",
                                                          69: "Hold 2",
                                                          70: "Sound variation",
                                                          71: "Harmonic content",
                                                          72: "Release time",
                                                          73: "Attack time",
                                                          74: "Brightness",
                                                          75: "Decay time",
                                                          76: "Vibrato rate",
                                                          77: "Vibrato depth",
                                                          78: "Vibrato delay",

                                                          80: "General purpose controller 5",
                                                          81: "General purpose controller 6",
                                                          82: "General purpose controller 7",
                                                          83: "General purpose controller 8",
                                                          84: "Portamento control",

                                                          88: "High resolution velocity prefix",

                                                          91: "Reverb send level",
                                                          92: "Tremelo depth",
                                                          93: "Chorus send level",
                                                          94: "Celeste depth",
                                                          95: "Phaser depth",
                                                          96: "Data increment",
                                                          97: "Data decrement",
                                                          98: "Non-registered parameter number LSB",
                                                          99: "Non-registered parameter number MSB",
                                                          100: "Registered parameter number LSB",
                                                          101: "Registered parameter number MSB",

                                                          120: "All sound off",
                                                          121: "Reset all controllers",
                                                          122: "Local control",
                                                          123: "All notes off",
                                                          124: "Omni mode off",
                                                          125: "Omni mode on",
                                                          126: "Mono mode on",
                                                          127: "Poly mode on"]

    private static let keySignatures: [SMFKeySignature: String] = [.aFlatMajor: "A♭ major",
                                                                   .aFlatMinor: "A♭ minor",
                                                                   .aMajor: "A major",
                                                                   .aMinor: "A minor",
                                                                   .aSharpMinor: "A♯",
                                                                   .bFlatMajor: "B♭ major",
                                                                   .bFlatMinor: "B♭ minor",
                                                                   .bMajor: "B major",
                                                                   .bMinor: "B minor",
                                                                   .cFlatMajor: "C♭ major",
                                                                   .cMajor: "C major",
                                                                   .cMinor: "C minor",
                                                                   .cSharpMajor: "C♯ major",
                                                                   .cSharpMinor: "C♯ minor",
                                                                   .dFlatMajor: "D♭ major",
                                                                   .dMajor: "D major",
                                                                   .dMinor: "D minor",
                                                                   .dSharpMinor: "D♯ minor",
                                                                   .eFlatMajor: "E♭ major",
                                                                   .eFlatMinor: "E♭ minor",
                                                                   .eMajor: "E major",
                                                                   .eMinor: "E minor",
                                                                   .fMajor: "F major",
                                                                   .fMinor: "F minor",
                                                                   .fSharpMajor: "F♯ major",
                                                                   .fSharpMinor: "F♯ minor",
                                                                   .gFlatMajor: "G♭ major",
                                                                   .gMajor: "G major",
                                                                   .gMinor: "G minor",
                                                                   .gSharpMinor: "G♯ minor"]

    // MARK: Private Instance Methods

    private func _asciify(_ dataByte: UInt8) -> String {
        switch dataByte {
        case 0x20...0x7e, 0xa1...0xff:
            String(Unicode.Scalar(dataByte))

        default:
            "."
        }
    }

    private func _asciify(_ bytes: [UInt8]) -> String {
        bytes.map { _asciify($0) }.joined(separator: " ")
    }

    private func _dump(_ indent: Int,
                       _ bytes: [UInt8],
                       chunkSize: Int = 16) {
        emit()

        var tmpBytes = bytes

        while !tmpBytes.isEmpty {
            let chunk = Array(tmpBytes.prefix(16))

            var line = chunk.hex

            if chunk.count < chunkSize {
                line += "   ".repeating(to: chunkSize - chunk.count)
            }

            line += spacer()
            line += _asciify(chunk)

            emit(indent, line)

            tmpBytes = Array(tmpBytes.dropFirst(chunk.count))
        }

        emit()
    }

    private func _dump(_ indent: Int,
                       _ event: SMFEvent,
                       _ division: SMFDivision) {
        var line = _format(event.eventTime,
                           division)

        line += spacer()

        var bytes: [UInt8]?

        switch event {
        case let .meta(_, message):
            line += _format(message)

        case let .midi(_, message):
            line += _format(message)

        case let .sysEx(_, message):
            line += _format(message)

            bytes = message.dataBytes
        }

        emit(indent, line)

        if let bytes {
            _dump(indent + 2, bytes)
        }
    }

    private func _dump(_ indent: Int,
                       _ sequence: SMFSequence) {
        let division = sequence.division
        let sformat = sequence.format
        let tracks = sequence.tracks

        var header = "Sequence"

        header += spacer()
        header += "Format "
        header += format(sformat.uintValue)
        header += spacer()
        header += format(tracks.count, "track")
        header += spacer()
        header += _format(division)

        emit()
        emit(indent, header)

        for (index, track) in tracks.enumerated() {
            _dump(indent + 2, track, index, division)
        }
    }

    private func _dump(_ indent: Int,
                       _ track: SMFTrack,
                       _ index: Int,
                       _ division: SMFDivision) {
        let events = track.events

        var header = "Track #"

        header += format(index + 1)
        header += spacer()
        header += format(events.count, "event")

        emit()
        emit(indent, header)

        if !events.isEmpty {
            emit()

            for event in events {
                _dump(indent + 2, event, division)
            }
        }
    }

    private func _format(_ channel: MIDIChannel) -> String {
        format(channel.uintValue)
    }

    private func _format(_ controller: MIDIController) -> String {
        if let name = Self.controllerNames[controller.uintValue] {
            return name
        }

        var result = "Control change"

        result += spacer()
        result += format(controller.uintValue)

        return result
    }

    private func _format(_ division: SMFDivision) -> String {
        switch division {
        case let .metrical(tickRate):
            _format(tickRate)

        case let .timeCode(timeCode):
            _format(timeCode)
        }
    }

    private func _format(_ eventTime: SMFEventTime,
                         _ division: SMFDivision) -> String {
        switch division {
        case let .metrical(tickRate):
            _format(eventTime, tickRate)

        case let .timeCode(timeCode):
            _format(eventTime, timeCode)
        }
    }

    private func _format(_ eventTime: SMFEventTime,
                         _ tickRate: SMFTickRate) -> String {
        format(Double(eventTime.uintValue) / Double(tickRate.uintValue),
               precision: 3...3)
    }

    private func _format(_ eventTime: SMFEventTime,
                         _ timeCode: SMPTETimeCode) -> String {
        "\(eventTime)"  // TODO
    }

    private func _format(_ frameRate: SMPTEFrameRate) -> String {
        switch frameRate {
        case .fps24:
            "24fps"

        case .fps25:
            "25fps"

        case .fps30df:
            "30fps DF"

        case .fps30ndf:
            "30fps NDF"
        }
    }

    private func _format(_ keySignature: SMFKeySignature) -> String {
        Self.keySignatures[keySignature] ?? "\(keySignature)"
    }

    private func _format(_ message: MIDIChannelMessage) -> String {
        var result = _format(message.channel)

        result += spacer()

        switch message {
        case let .channelPressure(_, value):
            result += "Channel pressure"
            result += spacer()
            result += _format(value)

        case let .controlChange(_, controller, value):
            result += _format(controller)
            result += spacer()
            result += _format(value)

        case let .noteOff(_, key, velocity):
            result += "Note off"
            result += spacer()
            result += _format(key)
            result += spacer()
            result += _format(velocity)

        case let .noteOn(_, key, velocity):
            result += "Note on"
            result += spacer()
            result += _format(key)
            result += spacer()
            result += _format(velocity)

            if velocity == 0 {
                result += " (= off)"
            }

        case let .pitchBendChange(_, change):
            result += "Pitch bend change"
            result += spacer()
            result += _format(change)

        case let .polyphonicPressure(_, key, value):
            result += "Polyphonic pressure"
            result += spacer()
            result += _format(key)
            result += spacer()
            result += _format(value)

        case let .programChange(_, program):
            result += "Program change"
            result += spacer()
            result += _format(program)
        }

        return result
    }

    private func _format(_ message: SMFMetaMessage) -> String {
        var result = ""

        switch message {
        case let .copyright(text):
            result += "Copyright"
            result += spacer()
            result += _format(text)

        case let .cuePoint(text):
            result += "Cue point"
            result += spacer()
            result += _format(text)

        case let .deviceName(text):
            result += "Device name"
            result += spacer()
            result += _format(text)

        case .endOfTrack:
            result += "End of track"

        case let .instrumentName(text):
            result += "Instrument name"
            result += spacer()
            result += _format(text)

        case let .keySignature(keySignature):
            result += "Key signature"
            result += spacer()
            result += _format(keySignature)

        case let .lyric(text):
            result += "Lyric"
            result += spacer()
            result += _format(text)

        case let .marker(text):
            result += "Marker"
            result += spacer()
            result += _format(text)

        case let .midiChannelPrefix(channel):
            result += "MIDI channel prefix"
            result += spacer()
            result += _format(channel)

        case let .midiPort(port):
            result += "MIDI port"
            result += spacer()
            result += _format(port)

        case let .programName(text):
            result += "Program name"
            result += spacer()
            result += _format(text)

        case let .sequenceNumber(seqNum):
            result += "Sequence number"
            result += spacer()
            result += _format(seqNum)

        case let .sequencerSpecific(bytes):
            result += "Sequencer-specific"
            result += spacer()
            result += bytes.hex

        case let .sequenceTrackName(text):
            result += "Sequence/track name"
            result += spacer()
            result += _format(text)

        case let .smpteOffset(time):
            result += "SMPTE offset"
            result += spacer()
            result += _format(time)

        case let .tempo(tempo):
            result += "Tempo"
            result += spacer()
            result += _format(tempo)

        case let .text(text):
            result += "Text"
            result += spacer()
            result += _format(text)

        case let .timeSignature(timeSignature):
            result += "Time signature"
            result += spacer()
            result += _format(timeSignature)
        }

        return result
    }

    private func _format(_ message: SMFSysExMessage) -> String {
        var result = ""

        switch message {
        case let .escape(bytes):
            result += "Escape"
            result += spacer()
            result += format(bytes.count, "byte")

        case let .systemExclusive(bytes):
            result += "System exclusive"
            result += spacer()
            result += format(bytes.count, "byte")
        }

        return result
    }

    private func _format(_ pitchBend: MIDIPitchBend) -> String {
        format(pitchBend.intValue)
    }

    private func _format(_ tempo: SMFTempo) -> String {
        var result = format(tempo.uintValue, "µsecond")

        result += "/quarter-note"

        return result
    }

    private func _format(_ text: SMFText) -> String {
        format(text.stringValue)
    }

    private func _format(_ tickRate: SMFTickRate) -> String {
        let rawTickRate = tickRate.uintValue

        var result = format(rawTickRate, "tick")

        result += "/quarter-note"

        return result
    }

    private func _format(_ time: SMPTETime) -> String {
        var result = _format(time.frameRate)

        result += spacer()
        result += String(format: "%02d:%02d:%02d %02d.%02d",
                         time.hour,
                         time.minute,
                         time.second,
                         time.frame,
                         time.fraction)

        return result
    }

    private func _format(_ timeCode: SMPTETimeCode) -> String {
        var result = _format(timeCode.frameRate)

        result += spacer()
        result += format(timeCode.tickRate, "tick")
        result += "/frame"

        return result
    }

    private func _format(_ timeSignature: SMFTimeSignature) -> String {
        var result = format(timeSignature.numerator)

        result += "/"
        result += format(1 << timeSignature.denominator)
        result += spacer()
        result += format(timeSignature.clockRate, "clock")
        result += "/click"
        result += spacer()
        result += format(timeSignature.beatRate, "32nd-note")
        result += "/quarter-note"

        return result
    }

    private func _format(_ value: MIDIData1Value) -> String {
        format(value.uintValue)
    }

    private func _format(_ value: MIDIData2Value) -> String {
        format(value.uintValue)
    }

    private func _format(_ value: SMFData2Value) -> String {
        format(value.uintValue)
    }
}
