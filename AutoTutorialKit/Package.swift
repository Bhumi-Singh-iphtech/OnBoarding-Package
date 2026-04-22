// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AutoTutorialKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AutoTutorialKit",
            targets: ["AutoTutorialKit"]),
    ],
    targets: [
        .target(
            name: "AutoTutorialKit",
            path: "Sources/AutoTutorialKit"
        )
    ]
)
