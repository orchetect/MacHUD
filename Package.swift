// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HUDKit",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "HUDKit",
            targets: ["HUDKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.7.9")
    ],
    targets: [
        .target(
            name: "HUDKit",
            dependencies: ["OTCore"]
        ),
        .testTarget(
            name: "HUDKitTests",
            dependencies: ["HUDKit"]
        )
    ]
)
