// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

public struct SMFFormatter {

    // MARK: Public Initializers

    public init(_ sequence: SMFSequence) {
        self.chunkMode = false
        self.currentTime = 0
        self.outChunkData = Data()
        self.outData = Data()
        self.runningStatus = 0
        self.sequence = sequence
    }

    // MARK: Private Instance Properties

    private let sequence: SMFSequence

    private var chunkMode: Bool
    private var currentTime: UInt
    private var outChunkData: Data
    private var outData: Data
    private var runningStatus: UInt8
}

// MARK: -

extension SMFFormatter {

    // MARK: Public Instance Methods

    public mutating func format() throws -> Data {
        try _formatHeader(sequence.format,
                          UInt(sequence.tracks.count),
                          sequence.division)

        try sequence.tracks.forEach { try _formatTrack($0) }

        let data = outData

        outData.removeAll()

        return data
    }

    // MARK: Private Instance Methods

    private mutating func _formatAsByte(_ value: UInt) throws {
        guard let byte = UInt8(exactly: value)
        else { throw Error.invalidByte(value) }

        try _formatByte(byte)
    }

    private mutating func _formatAsWord(_ value: UInt) throws {
        guard (0...0x7fff).contains(value)
        else { throw Error.invalidWord(value) }

        try _formatAsByte(value >> 8)
        try _formatAsByte(value & 0xff)
    }

    private mutating func _formatByte(_ byte: UInt8) throws {
        if chunkMode {
            outChunkData.append(byte)
        } else {
            outData.append(byte)
        }
    }

    private mutating func _formatBytes(_ bytes: [UInt8]) throws {
        try bytes.forEach { try _formatByte($0) }
    }

    private mutating func _formatChunk(_ chunkType: SMFChunkType) throws {
        chunkMode = false

        try _formatChunkType(chunkType)
        try _formatChunkLength(UInt(outChunkData.count))

        outData.append(outChunkData)

        outChunkData.removeAll(keepingCapacity: true)
    }

    private mutating func _formatChunkLength(_ chunkLength: UInt) throws {
        guard (0...0x7fffffff).contains(chunkLength)
        else { throw Error.invalidChunkLength(chunkLength) }

        try _formatAsByte(chunkLength >> 24)
        try _formatAsByte((chunkLength >> 16) & 0xff)
        try _formatAsByte((chunkLength >> 8) & 0xff)
        try _formatAsByte(chunkLength & 0xff)
    }

    private mutating func _formatChunkType(_ chunkType: SMFChunkType) throws {
        for char in chunkType.stringValue {
            guard let byte = char.asciiValue
            else { throw Error.invalidChunkType(chunkType) }

            try _formatByte(byte)
        }
    }

    private mutating func _formatEvent(_ event: SMFEvent) throws {
        try _formatEventTime(event.eventTime)

        switch event {
        case let .meta(_, message):
            guard let statusByte = message.statusByte,
                  let typeByte = message.typeByte,
                  let dataBytes = message.dataBytes
            else { throw Error.invalidEvent(event) }

            runningStatus = 0

            try _formatByte(statusByte)
            try _formatByte(typeByte)
            try _formatVarlen(UInt(dataBytes.count))
            try _formatBytes(dataBytes)

        case let .midi(_, message):
            guard let statusByte = message.statusByte,
                  let dataBytes = message.dataBytes
            else { throw Error.invalidEvent(event) }

            if runningStatus != statusByte {
                runningStatus = statusByte

                try _formatByte(statusByte)
            }

            try _formatBytes(dataBytes)

        case let .sysEx(_, message):
            guard let statusByte = message.statusByte,
                  let dataBytes = message.dataBytes
            else { throw Error.invalidEvent(event) }

            runningStatus = 0

            try _formatByte(statusByte)
            try _formatVarlen(UInt(dataBytes.count))
            try _formatBytes(dataBytes)
        }
    }

    private mutating func _formatEventTime(_ eventTime: SMFEventTime) throws {
        let deltaTime = eventTime.uintValue - currentTime

        currentTime = eventTime.uintValue

        try _formatVarlen(deltaTime)
    }

    private mutating func _formatHeader(_ format: SMFFormat,
                                        _ trackCount: UInt,
                                        _ division: SMFDivision) throws {
        guard let fmtBytes = format.bytesValue
        else { throw Error.invalidFormat(format) }

        guard (format == .format0 && trackCount == 1) ||
                (format != .format0 && trackCount >= 1)
        else { throw Error.invalidTrackCount(trackCount) }

        guard let divBytes = division.bytesValue
        else { throw Error.invalidDivision(division) }

        chunkMode = true

        try _formatBytes(fmtBytes)
        try _formatAsWord(trackCount)
        try _formatBytes(divBytes)

        try _formatChunk(.header)
    }

    private mutating func _formatTrack(_ track: SMFTrack) throws {
        chunkMode = true

        try track.events.forEach { try _formatEvent($0) }

        try _formatChunk(.track)
    }

    private mutating func _formatVarlen(_ varlen: UInt) throws {
        guard (0...0x0fffffff).contains(varlen)
        else { throw Error.invalidVarlen(varlen) }

        var stack: [UInt] = []
        var varlen = varlen

        stack.push(varlen & 0x7f)

        for _ in 1..<4 {
            varlen >>= 7

            guard varlen > 0
            else { break }

            stack.push((varlen & 0x7f) | 0x80)
        }

        while let value = stack.pop() {
            try _formatAsByte(value)
        }
    }
}
