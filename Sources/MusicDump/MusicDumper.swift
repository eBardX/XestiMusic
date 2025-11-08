// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct MusicDumper {

    // MARK: Public Initializers

    internal init(_ stdio: StandardIO) {
        self.stdio = stdio
    }

    // MARK: Public Methods

    func dump(_ fileURL: URL) throws {
        switch fileURL.pathExtension {
        case "abc":
            try dumpABC(fileURL)

        case "dkm", "johnnysonic":
            try dumpDKM(fileURL)

        case "gmn":
            try dumpGMN(fileURL)

        case "mid", "midi", "smf":
            try dumpMIDI(fileURL)

        case "musicxml", "xml":
            try dumpMusicXML(fileURL)

        case "mxl":
            try dumpMXL(fileURL)

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

    internal func dumpABC(_ fileURL: URL) throws {
        emit("Dump of ABC File “\(fileURL.path)”")
    }

    internal func dumpDKM(_ fileURL: URL) throws {
        emit("Dump of JohnnySonic Score File “\(fileURL.path)”")
    }

    internal func dumpGMN(_ fileURL: URL) throws {
        emit("Dump of Guido Score File “\(fileURL.path)”")
    }

    internal func dumpMXL(_ fileURL: URL) throws {
        emit("Dump of Compressed MusicXML Document “\(fileURL.path)”")
    }

    internal func dumpMusicXML(_ fileURL: URL) throws {
        emit("Dump of MusicXML Document “\(fileURL.path)”")
    }

    internal func emit(_ line: String = "") {
        stdio.writeOutput(line)
    }

    internal func emit(_ indent: Int,
                       _ line: String) {
        if indent > 0 {
            stdio.writeOutput(" ".repeating(to: indent),
                              "")
        }

        stdio.writeOutput(line)
    }

    internal func emitError(_ message: String) {
        stdio.writeError(message)
    }

    internal func readFile(_ fileURL: URL) throws -> Data {
        let file = try FileWrapper(url: fileURL,
                                   options: .immediate)

        return file.regularFileContents ?? Data()
    }
}
