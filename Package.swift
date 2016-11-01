import PackageDescription

let package = Package(
  name: "Argo",
  dependencies: [
    .Package(url: "https://github.com/thoughtbot/Runes.git", majorVersion: 4)
  ]
)
