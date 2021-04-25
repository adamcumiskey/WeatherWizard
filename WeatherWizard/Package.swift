// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "WeatherWizard",
  platforms: [
    .iOS(.v14),
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "CurrentWeather",
      targets: ["CurrentWeather"]
    ),
    .library(
      name: "Formatter",
      targets: ["Formatter"]
    ),
    .library(
      name: "FullForecast",
      targets: ["FullForecast"]
    ),
    .library(
      name: "Geocoder",
      targets: ["Geocoder"]
    ),
    .library(
      name: "LocationSearch",
      targets: ["LocationSearch"]
    ),
    .library(
      name: "OpenWeatherAPI",
      targets: ["OpenWeatherAPI"]
    ),
    .library(
      name: "TemperatureView",
      targets: ["TemperatureView"]
    ),
    .library(
      name: "WeatherWizard",
      targets: ["WeatherWizard"]
    ),
    .library(
      name: "Wizard",
      targets: ["Wizard"]
    ),
    .library(
      name: "WizardButton",
      targets: ["WizardButton"]
    ),
    .library(
      name: "WizardSelection",
      targets: ["WizardSelection"]
    ),
    .library(
      name: "WizardStorage",
      targets: ["WizardStorage"]
    )
  ],
  dependencies: [
    .package(name: "Request", url: "https://github.com/carson-katri/swift-request.git", .branch("main")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.18.0"),
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2")
  ],
  targets: [
    .target(
      name: "CurrentWeather",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Formatter",
        "OpenWeatherAPI",
        "TemperatureView"
      ]
    ),
    .testTarget(
      name: "CurrentWeatherTests",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "CurrentWeather",
        "SnapshotTesting"
      ]
    ),
    .target(
      name: "Formatter"
    ),
    .target(
      name: "FullForecast",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Formatter",
        "Geocoder",
        "OpenWeatherAPI",
        "TemperatureView",
      ]
    ),
    .testTarget(
      name: "FullForecastTests",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "FullForecast",
        "SnapshotTesting"
      ]
    ),
    .target(
      name: "Geocoder"
    ),
    .target(
      name: "LocationSearch",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "LocationSearchTests",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "LocationSearch",
        "SnapshotTesting",
      ]
    ),
    .target(
      name: "OpenWeatherAPI",
      dependencies: [
        "Request"
      ]
    ),
    .target(
      name: "TemperatureView",
      dependencies: ["Formatter"]
    ),
    .target(
      name: "WeatherWizard",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "CurrentWeather",
        "FullForecast",
        "Geocoder",
        "LocationSearch",
        "WizardSelection",
      ]
    ),
    .testTarget(
      name: "WeatherWizardTests",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "WeatherWizard",
        "SnapshotTesting"
      ]
    ),
    .target(name: "Wizard"),
    .target(
      name: "WizardButton",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Wizard",
        "WizardStorage"
      ]
    ),
    .target(
      name: "WizardSelection",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "WizardButton",
        "WizardStorage"
      ]
    ),
    .target(
      name: "WizardStorage",
      dependencies: ["Wizard"]
    )
  ]
)
