// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonSwiftUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CommonSwiftUI",
            targets: ["CommonSwiftUI"]),
    ],
    dependencies: [
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", from: "3.1.8")
    ],
    targets: [
        .target(name: "CommonSwiftUI", dependencies: ["Lottie"])
    ]
)
