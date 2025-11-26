// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-hud",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftHUD",
            targets: ["SwiftHUD"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-extensions", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "SwiftHUD",
            dependencies: [
                .product(name: "SwiftExtensions", package: "swift-extensions")
            ]
        ),
        .testTarget(
            name: "SwiftHUDTests",
            dependencies: ["SwiftHUD"]
        )
    ]
)
