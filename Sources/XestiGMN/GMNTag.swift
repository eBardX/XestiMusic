// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNTag {

    // MARK: Public Initializers

    public init(name: String,
                ident: UInt?,
                parameters: [Parameter],
                symbols: [GMNSymbol]) {
        self.ident = ident
        self.name = name
        self.parameters = parameters
        self.symbols = symbols
    }

    // MARK: Public Instance Properties

    public let ident: UInt?
    public let name: String
    public let parameters: [Parameter]
    public let symbols: [GMNSymbol]
}

// MARK: - Sendable

extension GMNTag: Sendable {
}
