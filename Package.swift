// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SplitScreenScanner",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SplitScreenScanner",
            targets: ["SplitScreenScanner"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/litso/Sections.git", .upToNextMajor(from: "0.10.1"))
    ],
    targets: [
        .target(
            name: "SplitScreenScanner",
            dependencies: [
                "Sections"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
