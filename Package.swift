// swift-tools-version: 5.9

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
        .package(url: "https://github.com/orchetect/OTCore", from: "1.6.0")
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
