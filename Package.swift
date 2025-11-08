// swift-tools-version: 6.2

// © 2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiMusic",
                      platforms: [.iOS(.v18),
                                  .macOS(.v15)],
                      products: [.executable(name: "mdump",
                                             targets: ["MusicDump"]),
                                 .library(name: "XestiABC",
                                          targets: ["XestiABC"]),
                                 .library(name: "XestiDKM",
                                          targets: ["XestiDKM"]),
                                 .library(name: "XestiGMN",
                                          targets: ["XestiGMN"]),
                                 .library(name: "XestiMXL",
                                          targets: ["XestiMXL"]),
                                 .library(name: "XestiSMF",
                                          targets: ["XestiSMF"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiTools.git",
                                              branch: "swift-6.2-support"),
                                     .package(url: "https://github.com/eBardX/XestiXML.git",
                                              branch: "swift-6.2-support")],
                      targets: [.executableTarget(name: "MusicDump",
                                                  dependencies: [.target(name: "XestiABC"),
                                                                 .target(name: "XestiDKM"),
                                                                 .target(name: "XestiGMN"),
                                                                 .target(name: "XestiMXL"),
                                                                 .target(name: "XestiSMF")]),
                                .target(name: "XestiABC",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .target(name: "XestiDKM",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .target(name: "XestiGMN",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .target(name: "XestiMXL",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools"),
                                                       .product(name: "XestiXML",
                                                                package: "XestiXML")]),
                                .target(name: "XestiSMF",
                                        dependencies: [.product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .testTarget(name: "XestiABCTests",
                                            dependencies: [.target(name: "XestiABC")]),
                                .testTarget(name: "XestiDKMTests",
                                            dependencies: [.target(name: "XestiDKM")]),
                                .testTarget(name: "XestiGMNTests",
                                            dependencies: [.target(name: "XestiGMN")]),
                                .testTarget(name: "XestiMXLTests",
                                            dependencies: [.target(name: "XestiMXL")]),
                                .testTarget(name: "XestiSMFTests",
                                            dependencies: [.target(name: "XestiSMF")])],
                      swiftLanguageModes: [.v6])

let swiftSettings: [SwiftSetting] = [.defaultIsolation(nil),
                                     .enableUpcomingFeature("ExistentialAny")]

for target in package.targets {
    var settings = target.swiftSettings ?? []

    settings.append(contentsOf: swiftSettings)

    target.swiftSettings = settings
}
