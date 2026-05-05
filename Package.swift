// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AZW3",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "AZW3", targets: ["AZW3"]),
    ],
    targets: [
        .target(name: "AZW3"),
        .testTarget(
            name: "AZW3Tests",
            dependencies: ["AZW3"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
