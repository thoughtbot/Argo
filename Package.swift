// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Argo",
  products: [
    .library(name: "Argo", targets: ["Argo"]),
  ],
  dependencies: [
    .package(url: "https://github.com/thoughtbot/Runes.git", .branch("swift-4")),
    .package(url: "https://github.com/thoughtbot/Curry.git", from: "3.0.0"),
  ],
  targets: [
    .target(
      name: "Argo",
      dependencies: [
        "Runes",
      ]
    ),
    .testTarget(
      name: "Fixtures"
    ),
    .testTarget(
      name: "ArgoTests",
      dependencies: [
        "Argo",
        "Curry",
        "Fixtures",
      ]
    ),
  ],
  swiftLanguageVersions: [3, 4]
)
