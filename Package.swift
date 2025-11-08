// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ClipboardOCR",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ClipboardOCR",
            dependencies: [],
            path: "Sources"
        )
    ]
)
