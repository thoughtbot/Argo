// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Argo",
  products: [.library(name: "Argo", targets: ["Argo"])],
  dependencies: [
    .package(url: "https://github.com/thoughtbot/Runes.git", from: "4.2.1")
  ],
  targets: [
    .target(
      name: "Argo",
      dependencies: ["Runes"],
      path: "Sources"
    )
  ]
)
