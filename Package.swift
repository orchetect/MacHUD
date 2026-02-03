// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MacHUD",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MacHUD",
            targets: ["MacHUD"]
        )
    ],
    traits: [
        .trait(name: "Logging", description: "Enables debug logging."),
        .default(enabledTraits: ["Logging"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-extensions", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "MacHUD",
            dependencies: [
                .product(name: "SwiftExtensions", package: "swift-extensions")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=complete"),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances")
            ]
        )
    ]
)
