// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pcb2photon",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SwiftGL/Image.git", from: "2.0.0"),
    ],
    targets: [
        // Library target containing the converter implementation.
        .target(
            name: "pcb2photonlib",
            dependencies: ["SGLImage"],
            path: "Sources/pcb2photonLib"),
        // Executable target that provides the command line interface.
        .target(
            name: "pcb2photon",
            dependencies: ["pcb2photonlib"],
            path: "Sources/pcb2photon"),
        // Unit test target.
        .testTarget(
            name: "pcb2photonTests",
            dependencies: ["pcb2photonlib"])
    ]
)
