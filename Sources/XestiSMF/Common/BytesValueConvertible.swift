// © 2025 John Gary Pusey (see LICENSE.md)

public protocol BytesValueConvertible {
    init?(_ bytesValue: [UInt8])

    var bytesValue: [UInt8]? { get }
}
