// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct MusicDumper {

    // MARK: Public Initializers

    public init(_ stdio: StandardIO) {
        self.stdio = stdio
    }

    // MARK: Public Methods

    public func dump(_ fileURL: URL) throws {
        switch fileURL.pathExtension {
        case "abc":
            try dumpABC(fileURL)

        case "dkm", "johnnysonic":
            try dumpJohnnySonic(fileURL)

        case "gmn":
            try dumpGuido(fileURL)

        case "mid", "midi", "smf":
            try dumpMIDI(fileURL)

        case "musicxml", "mxl", "xml":
            try dumpMusicXML(fileURL)

        default:
            emitError("Unrecognized file format: “\(fileURL.path)”")
        }
    }

    // MARK: Private Instance Properties

    private let stdio: StandardIO
}

// MARK: -

extension MusicDumper {

    // MARK: Internal Instance Methods

    internal func emit(_ line: String = "") {
        stdio.writeOutput(line)
    }

    internal func emitError(_ message: String) {
        stdio.writeError(message)
    }
}
