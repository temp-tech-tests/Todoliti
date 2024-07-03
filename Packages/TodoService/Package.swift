// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TodoService",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "TodoService",
            targets: ["TodoService"]),
    ],
    targets: [
        .target(
            name: "TodoService"),
        .testTarget(
            name: "TodoServiceTests",
            dependencies: ["TodoService"]),
    ]
)
