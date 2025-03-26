// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OneNavigation",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "OneNavigation",
            targets: ["OneNavigation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", from: Version(5, 3, 0))
    ],
    targets: [
        .target(
            name: "OneNavigation",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ],
            resources: [
                .process("../Resources/Colors.xcassets")
            ]
        ),
        .testTarget(
            name: "OneNavigationTests",
            dependencies: ["OneNavigation"]
        )
    ]
)
