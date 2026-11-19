// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "devcycle_flutter_client_sdk",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "devcycle-flutter-client-sdk", targets: ["devcycle_flutter_client_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/DevCycleHQ/ios-client-sdk.git", exact: "1.26.1")
    ],
    targets: [
        .target(
            name: "devcycle_flutter_client_sdk",
            dependencies: [
                .product(name: "DevCycle", package: "ios-client-sdk")
            ]
        )
    ]
)
