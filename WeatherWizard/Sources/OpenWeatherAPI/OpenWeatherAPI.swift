import Combine
import CoreLocation
import Foundation
import Request

public struct OpenWeatherAPI {
  /// Given a query string, return the current weather
  public let getCurrentWeather: (String) -> AnyPublisher<CurrentWeatherResponse, Error>
  /// Given a coordinate, return the one-call forecast
  public let getOneCallForecast: (CLLocationCoordinate2D) -> AnyPublisher<OneCallForecastResponse, Error>
}

enum OpenWeatherAPIError: Error {
  case failing
}

public extension OpenWeatherAPI {
  static var live: OpenWeatherAPI {
    let appID = ProcessInfo.processInfo.environment["OPEN_WEATHER_API_KEY"] ?? ""
    return OpenWeatherAPI(
      getCurrentWeather: { query in
        return AnyRequest<CurrentWeatherResponse> {
          Url("https://api.openweathermap.org/data/2.5/weather")
          Query([
            "q": query
              .components(separatedBy: ",")
              .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
              .joined(separator: ","),
            "appid": appID
          ])
        }
        .objectPublisher
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
      },
      getOneCallForecast: { coord in
        return AnyRequest<OneCallForecastResponse> {
          Url("https://api.openweathermap.org/data/2.5/onecall")
          Query(["lat": "\(coord.latitude)", "lon": "\(coord.longitude)", "appid": appID])
        }
        .objectPublisher
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
      }
    )
  }

  static var mock: OpenWeatherAPI {
    return OpenWeatherAPI(
      getCurrentWeather: { name in
        Just(.mock)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
      },
      getOneCallForecast: { _ in
        return Just(.mock)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
      }
    )
  }

  static var failing: OpenWeatherAPI {
    return .init(
      getCurrentWeather: { _ in Fail(error: OpenWeatherAPIError.failing).eraseToAnyPublisher() },
      getOneCallForecast: { _ in Fail(error: OpenWeatherAPIError.failing).eraseToAnyPublisher() }
    )
  }
}
