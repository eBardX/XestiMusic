// © 2025 John Gary Pusey (see LICENSE.md)

public struct GMNChord {

    // MARK: Public Initializers

    public init(_ segments: [Segment]) {
        self.segments = segments
    }

    // MARK: Public Instance Properties

    public let segments: [Segment]
}

// MARK: - Sendable

extension GMNChord: Sendable {
}
