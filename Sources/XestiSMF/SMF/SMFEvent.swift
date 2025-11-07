// © 2025 John Gary Pusey (see LICENSE.md)

public enum SMFEvent {
    case meta(SMFEventTime, SMFMetaMessage)
    case midi(SMFEventTime, MIDIChannelMessage)
    case sysEx(SMFEventTime, SMFSysExMessage)
}

// MARK: -

extension SMFEvent {

    // MARK: Public Instance Properties

    public var eventTime: SMFEventTime {
        switch self {
        case let .meta(eventTime, _),
            let .midi(eventTime, _),
            let .sysEx(eventTime, _):
            eventTime
        }
    }
}

// MARK: - Codable

extension SMFEvent: Codable {
}

// MARK: - Sendable

extension SMFEvent: Sendable {
}
