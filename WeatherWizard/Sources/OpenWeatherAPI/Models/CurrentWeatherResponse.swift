import Foundation

// MARK: - CurrentWeather
public struct CurrentWeatherResponse: Equatable, Codable {
//  public let coord: Coord
  public let weather: [Weather]
//  public let base: String
  public let main: Main
//  public let visibility: Int
//  public let wind: Wind
//  public let clouds: Clouds
//  public let dt: Int
//  public let sys: Sys
//  public let timezone, id: Int
  public let name: String
//  public let cod: Int

  // MARK: - Clouds
  public struct Clouds: Equatable, Codable {
    public let all: Int
  }

  // MARK: - Coord
  public struct Coord: Equatable, Codable {
    public let lon, lat: Double
  }

  // MARK: - Main
  public struct Main: Equatable, Codable {
    public let temp, feelsLike, tempMin, tempMax: Double
    public let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
      case temp
      case feelsLike = "feels_like"
      case tempMin = "temp_min"
      case tempMax = "temp_max"
      case pressure, humidity
    }
    public init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int) {
      self.temp = temp
      self.feelsLike = feelsLike
      self.tempMin = tempMin
      self.tempMax = tempMax
      self.pressure = pressure
      self.humidity = humidity
    }
  }

  // MARK: - Sys
  public struct Sys: Equatable, Codable {
    public let type, id: Int
    public let country: String
    public let sunrise, sunset: Int
  }

  // MARK: - Wind
  public struct Wind: Equatable, Codable {
    public let speed: Double
    public let deg: Int
  }

  public init(weather: [Weather], main: CurrentWeatherResponse.Main, name: String) {
    self.weather = weather
    self.main = main
    self.name = name
  }
}

// MARK: - Mock

extension CurrentWeatherResponse {
  public static var mock: CurrentWeatherResponse {
    CurrentWeatherResponse(
      weather: [
        .init(id: 801, main: .clouds)
      ],
      main: .init(
        temp: 293,
        feelsLike: 290,
        tempMin: 284,
        tempMax: 294,
        pressure: 1020,
        humidity: 73
      ),
      name: "London"
    )
  }
}
