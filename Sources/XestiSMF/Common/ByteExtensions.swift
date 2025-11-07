// © 2025 John Gary Pusey (see LICENSE.md)

extension UInt8 {
    public var hex: String {
        let hexString = String(self,
                               radix: 16,
                               uppercase: true)

        if hexString.count < 2 {
            return "0" + hexString
        }

        return hexString
    }
}

extension Sequence where Element == UInt8 {
    public var hex: String {
        map { $0.hex }.joined(separator: " ")
    }
}
