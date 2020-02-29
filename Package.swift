// swift-tools-version:5.0
import PackageDescription


let package = Package(
  name: "QueryKit",
  products: [
  ],
  targets: [
    .target(name: "QueryKit", dependencies: []),
    .testTarget(name: "QueryKitTests", dependencies: ["QueryKit"]),
  ]
)
