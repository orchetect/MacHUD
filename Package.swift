// swift-tools-version:5.3

import PackageDescription

let package = Package(
	
    name: "HUDKit",
	
	platforms: [
		.macOS(.v10_12)
	],
	
    products: [
        .library(
            name: "HUDKit",
            targets: ["HUDKit"])
    ],
	
    dependencies: [
		.package(url: "https://github.com/orchetect/OTCore", from: "1.1.24")
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
