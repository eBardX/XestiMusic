// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct MIDIController: UIntRepresentable {

    // MARK: Public Type Properties

    public static let invalidMessage = "MIDI controller must be between 0 and 127 (inclusive)"

    public static let allNotesOff                     = Self(123)
    public static let allSoundOff                     = Self(120)
    public static let attackTime                      = Self(73)
    public static let balanceLSB                      = Self(40)
    public static let balanceMSB                      = Self(8)
    public static let bankSelectLSB                   = Self(32)
    public static let bankSelectMSB                   = Self(0)
    public static let breathControllerLSB             = Self(34)
    public static let breathControllerMSB             = Self(2)
    public static let brightness                      = Self(74)
    public static let celesteDepth                    = Self(94)
    public static let channelVolumeLSB                = Self(39)
    public static let channelVolumeMSB                = Self(7)
    public static let chorusSendLevel                 = Self(93)
    public static let dataDecrement                   = Self(97)
    public static let dataEntryLSB                    = Self(38)
    public static let dataEntryMSB                    = Self(6)
    public static let dataIncrement                   = Self(96)
    public static let decayTime                       = Self(75)
    public static let effectControl1LSB               = Self(44)
    public static let effectControl1MSB               = Self(12)
    public static let effectControl2LSB               = Self(45)
    public static let effectControl2MSB               = Self(13)
    public static let expressionControllerLSB         = Self(43)
    public static let expressionControllerMSB         = Self(11)
    public static let footControllerLSB               = Self(36)
    public static let footControllerMSB               = Self(4)
    public static let generalPurposeController1LSB    = Self(48)
    public static let generalPurposeController2LSB    = Self(49)
    public static let generalPurposeController3LSB    = Self(50)
    public static let generalPurposeController4LSB    = Self(51)
    public static let generalPurposeController5       = Self(80)
    public static let generalPurposeController6       = Self(81)
    public static let generalPurposeController7       = Self(82)
    public static let generalPurposeController8       = Self(83)
    public static let genPurposeController1MSB        = Self(16)
    public static let genPurposeController2MSB        = Self(17)
    public static let genPurposeController3MSB        = Self(18)
    public static let genPurposeController4MSB        = Self(19)
    public static let harmonicContent                 = Self(71)
    public static let highResolutionVelocityPrefix    = Self(88)
    public static let hold2                           = Self(69)
    public static let legato                          = Self(68)
    public static let localControl                    = Self(122)
    public static let modulationWheelLSB              = Self(33)
    public static let modulationWheelMSB              = Self(1)
    public static let monoModeOn                      = Self(126)
    public static let nonRegisteredParameterNumberLSB = Self(98)
    public static let nonRegisteredParameterNumberMSB = Self(99)
    public static let omniModeOff                     = Self(124)
    public static let omniModeOn                      = Self(125)
    public static let panLSB                          = Self(42)
    public static let panMSB                          = Self(10)
    public static let phaserDepth                     = Self(95)
    public static let polyModeOn                      = Self(127)
    public static let portamento                      = Self(65)
    public static let portamentoControl               = Self(84)
    public static let portamentoTimeLSB               = Self(37)
    public static let portamentoTimeMSB               = Self(5)
    public static let registeredParameterNumberLSB    = Self(100)
    public static let registeredParameterNumberMSB    = Self(101)
    public static let releaseTime                     = Self(72)
    public static let resetAllControllers             = Self(121)
    public static let reverbSendLevel                 = Self(91)
    public static let softPedal                       = Self(67)
    public static let sostenuto                       = Self(66)
    public static let soundVariation                  = Self(70)
    public static let sustain                         = Self(64)
    public static let tremeloDepth                    = Self(92)
    public static let vibratoDelay                    = Self(78)
    public static let vibratoDepth                    = Self(77)
    public static let vibratoRate                     = Self(76)

    // MARK: Public Type Methods

    public static func isValid(_ uintValue: UInt) -> Bool {
        (1...127).contains(uintValue)
    }

    // MARK: Public Initializers

    public init(_ uintValue: UInt) {
        self.uintValue = Self.requireValid(uintValue)
    }

    // MARK: Public Instance Properties

    public let uintValue: UInt
}

// MARK: - BytesValueConvertible

extension MIDIController: BytesValueConvertible {

    // MARK: Public Initializers

    public init?(_ bytesValue: [UInt8]) {
        guard bytesValue.count == 1
        else { return nil }

        self.init(uintValue: UInt(bytesValue[0]))
    }

    // MARK: Public Instance Properties

    public var bytesValue: [UInt8]? {
        guard let byte0Value = UInt8(exactly: uintValue)
        else { return nil }

        return [byte0Value]
    }
}
