// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ArrivoData",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ArrivoData", targets: ["ArrivoData"])
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "ArrivoData",
            dependencies: [.product(name: "GRDB", package: "GRDB.swift")]
        ),
        .testTarget(name: "ArrivoDataTests", dependencies: ["ArrivoData"])
    ]
)
