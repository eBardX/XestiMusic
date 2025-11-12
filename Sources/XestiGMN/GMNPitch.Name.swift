// © 2025 John Gary Pusey (see LICENSE.md)

extension GMNPitch {
    public enum Name: String {
        case a     = "a"
        case b     = "b"
        case c     = "c"
        case d     = "d"
        case e     = "e"
        case f     = "f"
        case g     = "g"
        case h     = "h"
        case ais   = "ais"
        case cis   = "cis"
        case dis   = "dis"
        case fis   = "fis"
        case gis   = "gis"
        case `do`  = "do"
        case re    = "re"
        case mi    = "mi"
        case fa    = "fa"
        case sol   = "sol"
        case la    = "la"
        case si    = "si"
        case ti    = "ti"
        case empty = "empty"
    }
}

// MARK: - Sendable

extension GMNPitch.Name: Sendable {
}
