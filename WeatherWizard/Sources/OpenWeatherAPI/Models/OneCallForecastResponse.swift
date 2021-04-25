// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oneCallForecastResponse = try? newJSONDecoder().decode(OneCallForecastResponse.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation
import SwiftUI

// MARK: - OneCallForecastResponse
public struct OneCallForecastResponse: Codable, Equatable {
//  public let lat, lon: Double?
  public let timezone: String
  public let timezoneOffset: Int
//  public let current: Current?
//  public let minutely: [Minutely]?
  public let hourly: [Current]
  public let daily: [Daily]

  enum CodingKeys: String, CodingKey {
    case hourly
//    case lat, lon,
    case timezone
    case timezoneOffset = "timezone_offset"
//    case current, minutely, daily
    case daily
  }

//  public init(lat: Double?, lon: Double?, timezone: String?, timezoneOffset: Int?, current: Current?, minutely: [Minutely]?, hourly: [Current]?, daily: [Daily]?) {
//    self.lat = lat
//    self.lon = lon
//    self.timezone = timezone
//    self.timezoneOffset = timezoneOffset
//    self.current = current
//    self.minutely = minutely
//    self.hourly = hourly
//    self.daily = daily
//  }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Current
public struct Current: Codable, Equatable {
  public let dt: Int
//  public let sunrise, sunset: Int?
  public let temp: Double
//  public let feelsLike: Double?
  public let pressure, humidity: Int?
  public let dewPoint: Double
//  public let uvi: Double?
//  public let clouds, visibility: Int?
  public let windSpeed: Double?
  public let windDeg: Int?
//  public let windGust: Double?
  public let weather: [Weather]
//  public let pop: Double?

  enum CodingKeys: String, CodingKey {
    case dt, temp
//         case sunrise, sunset
//    case feelsLike = "feels_like"
    case pressure, humidity
    case dewPoint = "dew_point"
//    case uvi, clouds, visibility
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    //    case windGust = "wind_gust"
    case weather
  }

  public init(dt: Int, temp: Double, pressure: Int?, humidity: Int?, dewPoint: Double, windSpeed: Double?, windDeg: Int?, weather: [Weather]) {
    self.dt = dt
    self.temp = temp
    self.pressure = pressure
    self.humidity = humidity
    self.dewPoint = dewPoint
    self.windSpeed = windSpeed
    self.windDeg = windDeg
    self.weather = weather
  }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Weather
public struct Weather: Codable, Equatable {
  public let id: Int
  public let main: Main

  public init(id: Int, main: Main) {
    self.id = id
    self.main = main
  }

  public var image: Image {
    switch main {
    case .clear:
      return Image(systemName: "sun.max")
    case .clouds:
      switch id {
      case 801:
        return Image(systemName: "cloud.sun")
      case 802:
        return Image(systemName: "cloud")
      default:
        return Image(systemName: "smoke")
      }
    case .drizzle:
      return Image(systemName: "cloud.drizzle")
    case .rain:
      return Image(systemName: "cloud.rain")
    case .snow:
      return Image(systemName: "snow")
    case .thunderstorm:
      return Image(systemName: "cloud.bolt")
    case .mist, .fog:
      return Image(systemName: "cloud.fog")
    case .dust, .ash, .sand:
      return Image(systemName: "sun.dust")
    case .haze:
      return Image(systemName: "sun.haze")
    case .sqall:
      return Image(systemName: "wind")
    case .tornado:
      return Image(systemName: "tornado")
    }
  }
}

public enum Main: String, Codable, Equatable {
  case clear = "Clear"
  case clouds = "Clouds"
  case drizzle = "Drizzle"
  case rain = "Rain"
  case snow = "Snow"
  case thunderstorm = "Thunderstorm"
  case mist = "Mist"
  case haze = "Haze"
  case dust = "Dust"
  case fog = "Fog"
  case sand = "Sand"
  case ash = "Ash"
  case sqall = "Sqall"
  case tornado = "Tornado"
}

public enum Description: String, Codable, Equatable {
  case brokenClouds = "broken clouds"
  case clearSky = "clear sky"
  case fewClouds = "few clouds"
  case overcastClouds = "overcast clouds"
  case scatteredClouds = "scattered clouds"
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Daily
public struct Daily: Codable, Equatable {
  public let dt: Int?
  // sunrise, sunset, moonrise: Int?
//  public let moonset: Int?
//  public let moonPhase: Double?
  public let temp: Temp?
//  public let feelsLike: FeelsLike?
  public let pressure, humidity: Int?
  public let dewPoint, windSpeed: Double?
  public let windDeg: Int?
  public let windGust: Double?
  public let weather: [Weather]
//  public let clouds: Int?
//  public let pop, uvi: Double?

  enum CodingKeys: String, CodingKey {
    case dt
//    case sunrise, sunset, moonrise, moonset
//    case moonPhase = "moon_phase"
    case temp
//    case feelsLike = "feels_like"
    case pressure, humidity
    case dewPoint = "dew_point"
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case windGust = "wind_gust"
    case weather
//    case weather, clouds, pop, uvi
  }
//
//  public init(dt: Int?, sunrise: Int?, sunset: Int?, moonrise: Int?, moonset: Int?, moonPhase: Double?, temp: Temp?, feelsLike: FeelsLike?, pressure: Int?, humidity: Int?, dewPoint: Double?, windSpeed: Double?, windDeg: Int?, windGust: Double?, weather: [Weather]?, clouds: Int?, pop: Double?, uvi: Double?) {
//    self.dt = dt
//    self.sunrise = sunrise
//    self.sunset = sunset
//    self.moonrise = moonrise
//    self.moonset = moonset
//    self.moonPhase = moonPhase
//    self.temp = temp
//    self.feelsLike = feelsLike
//    self.pressure = pressure
//    self.humidity = humidity
//    self.dewPoint = dewPoint
//    self.windSpeed = windSpeed
//    self.windDeg = windDeg
//    self.windGust = windGust
//    self.weather = weather
//    self.clouds = clouds
//    self.pop = pop
//    self.uvi = uvi
//  }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - FeelsLike
public struct FeelsLike: Codable, Equatable {
  public let day, night, eve, morn: Double?

  public init(day: Double?, night: Double?, eve: Double?, morn: Double?) {
    self.day = day
    self.night = night
    self.eve = eve
    self.morn = morn
  }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Temp
public struct Temp: Codable, Equatable {
  public let day, min, max, night: Double?
  public let eve, morn: Double?

  public init(day: Double?, min: Double?, max: Double?, night: Double?, eve: Double?, morn: Double?) {
    self.day = day
    self.min = min
    self.max = max
    self.night = night
    self.eve = eve
    self.morn = morn
  }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Minutely
public struct Minutely: Codable, Equatable {
  public let dt, precipitation: Int?

  public init(dt: Int?, precipitation: Int?) {
    self.dt = dt
    self.precipitation = precipitation
  }
}

// Mock

extension OneCallForecastResponse {
  public static var mock: OneCallForecastResponse {
    OneCallForecastResponse(
      timezone: "America/New_York",
      timezoneOffset: -(5 * 60 * 60),
      hourly: (0..<7).map { (i: Int) in
        .init(
          dt: Int(Date().timeIntervalSince1970 + Double(i * 60 * 60)),
          temp: 293,
          pressure: 1013,
          humidity: 30,
          dewPoint: 280,
          windSpeed: 4,
          windDeg: 2,
          weather: [
            Weather(id: 801, main: .clouds)
          ]
        )
      },
      daily: (0..<7).map { i in
        return .init(
          dt: Int(Date().timeIntervalSince1970 + Double(i * 60 * 60 * 24)),
          temp: .init(day: 290, min: 290, max: 290, night: 290, eve: 290, morn: 290),
          pressure: 1003,
          humidity: 23,
          dewPoint: 260,
          windSpeed: 2,
          windDeg: 1,
          windGust: 0.3,
          weather: [
            Weather(id: 801, main: .clouds)
          ]
        )
      }
    )
  }
}
