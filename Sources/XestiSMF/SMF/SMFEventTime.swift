// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct SMFEventTime: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "SMF time must be between 0 and 0x7fffffff (inclusive)"

    public static let zero = Self(0)

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: Int) -> Bool {
        (0...0x7fffffff).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: -

extension SMFEventTime {

    // MARK: Public Instance Methods

    public func beatTime(_ tickRate: SMFTickRate) -> Double {
        Double(uintValue) / Double(tickRate.uintValue)
    }

    public func smpteTime(_ timeCode: SMPTETimeCode) -> SMPTETime {
        let (frames, subframe) = uintValue.quotientAndRemainder(dividingBy: timeCode.tickRate)
        let (seconds, frame) = frames.quotientAndRemainder(dividingBy: timeCode.frameRate.uintValue)
        let (minutes, second) = seconds.quotientAndRemainder(dividingBy: 60)
        let (hour, minute) = minutes.quotientAndRemainder(dividingBy: 60)
        let fraction = UInt(Double(subframe) * 100 / Double(timeCode.tickRate))

        return SMPTETime(frameRate: timeCode.frameRate,
                         hour: hour,
                         minute: minute,
                         second: second,
                         frame: frame,
                         fraction: fraction)!   // swiftlint:disable:this force_unwrapping
    }
}
