// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public enum ABCSymbol {
    case annotation(String)
    case barLine(String)
    case brokenRhythm(String)
    case chord([ABCNote], ABCFraction)
    case graceNotes(Bool, [ABCNote])    // Bool == hasSlash
    case longDecoration(String)
    case note(ABCNote)
    case `repeat`(String)
    case rest(String, ABCFraction)
    case shortDecoration(String)
    case slur(String)
    case spacer(String)
    case tuplet(UInt, UInt, UInt)       // p:q:r
    case variantEnding(String)
}

// MARK: - Sendable

extension ABCSymbol: Sendable {
}
