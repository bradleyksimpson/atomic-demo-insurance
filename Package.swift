// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Demo Insurance", 
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Demo Insurance",
            targets: ["Demo Insurance"]
        ),
    ],
    dependencies: [
        // Official AtomicSwiftUISDK
        .package(
            url: "https://github.com/atomic-app/action-cards-swiftui-sdk-releases",
            from: "25.2.0"
        )
    ],
    targets: [
        .target(
            name: "Demo Insurance",
            dependencies: [
                .product(name: "AtomicSDK", package: "action-cards-swiftui-sdk-releases"),
                .product(name: "AtomicSwiftUISDK", package: "action-cards-swiftui-sdk-releases")
            ]
        )
    ]
)