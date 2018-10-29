// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "College-Confidential-Scraper-Vapor",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "SwiftSoup", "MongoKitten"]),
        .target( name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

