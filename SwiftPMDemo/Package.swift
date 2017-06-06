import PackageDescription

let package = Package(
    name: "SwiftPMDemo",
    dependencies: [
        .Package(url: "https://github.com/thoughtbot/Argo.git", "4.1.0"),
        .Package(url: "https://github.com/thoughtbot/Curry.git", "3.0.0"),
    ]
)
