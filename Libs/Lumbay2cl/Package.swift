// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lumbay2cl",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Lumbay2cl",
            targets: ["Lumbay2cl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", exact: "2.1.2"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", exact: "1.2.0"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", exact: "1.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Lumbay2cl",
            dependencies: [
                .product(name: "GRPCCore", package: "grpc-swift"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
            ]
        ),
        .testTarget(
            name: "Lumbay2clTests",
            dependencies: ["Lumbay2cl"]
        ),
    ]
)
