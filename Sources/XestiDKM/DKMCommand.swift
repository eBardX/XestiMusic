// © 2025 John Gary Pusey (see LICENSE.md)

public enum DKMCommand: String {
    case chorus          = "Chorus"
    case clip            = "Clip"
    case comment
    case compress        = "Compress"
    case dynamics        = "Dynamics"
    case end             = "End"
    case exclude         = "Exclude"
    case filter          = "Filter"
    case flange          = "Flange"
    case freqBandAnalyze = "FBA"
    case geq             = "GEQ"
    case haas            = "Haas"
    case include         = "Include"
    case levels          = "Levels"
    case mix             = "Mix"
    case pitches         = "Pitches"
    case pulse           = "Pulse"
    case reverb          = "Reverb"
    case screenOut       = "ScreenOut"
    case sendBack        = "SendBack"
    case showBuffer      = "ShowBuffer"
    case soundFileName   = "SFN"
    case stats           = "Stats"
    case tempo           = "Tempo"
    case tuning          = "Tuning"
    case vocode          = "Vocode"
}

// MARK: - Codable

extension DKMCommand: Codable {
}

// MARK: - Sendable

extension DKMCommand: Sendable {
}
