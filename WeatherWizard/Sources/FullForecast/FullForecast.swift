import Combine
import ComposableArchitecture
import CoreLocation
import Formatter
import Geocoder
import OpenWeatherAPI
import SwiftUI

// MARK: - State

public struct FullForecastState: Equatable {
  public var query: String?
  public var coord: CLLocationCoordinate2D?
  public var forecast: OneCallForecastResponse?
  public var error: String?

  public init(query: String? = nil, coord: CLLocationCoordinate2D? = nil, forecast: OneCallForecastResponse? = nil, error: String? = nil) {
    self.query = query
    self.coord = coord
    self.forecast = forecast
    self.error = error
  }
}

// MARK: - Action

public enum FullForecastAction: Equatable {
  case reset
  case setQuery(String)
  case geocodeSuccess(CLLocationCoordinate2D)
  case geocodeError(String)
  case apiResponse(OneCallForecastResponse)
  case apiError(String)
}

// MARK: - Environment

public struct FullForecastEnvironment {
  let api: OpenWeatherAPI
  let geocoder: Geocoder

  public init(api: OpenWeatherAPI, geocoder: Geocoder) {
    self.api = api
    self.geocoder = geocoder
  }

  public static var live: FullForecastEnvironment {
    return .init(
      api: .live,
      geocoder: .live
    )
  }

  public static var mock: FullForecastEnvironment {
    return .init(
      api: .mock,
      geocoder: .mock
    )
  }

  public static var failing: FullForecastEnvironment {
    return .init(
      api: .failing,
      geocoder: .failing
    )
  }
}

// MARK: - Reducer

public let fullForecastReducer = Reducer<FullForecastState, FullForecastAction, FullForecastEnvironment> { state, action, env in
  switch action {
  case .reset:
    state.query = nil
    state.coord = nil
    state.forecast = nil
    state.error = nil
    return .none
  case .setQuery(let query):
    state.query = query
    return Effect(env.geocoder.getCoordinate(query))
      .catchToEffect()
      .map { result in
        switch result {
        case .success(let coord):
          return .geocodeSuccess(coord)
        case .failure(let error):
          return .geocodeError(error.localizedDescription)
        }
      }
  case .geocodeSuccess(let coord):
    state.coord = coord
    return Effect(env.api.getOneCallForecast(coord))
      .catchToEffect()
      .map { result in
        switch result {
        case .success(let forecast):
          return .apiResponse(forecast)
        case .failure(let error):
          return .apiError(error.localizedDescription)
        }
      }
  case .apiResponse(let forecast):
    state.forecast = forecast
    return .none
  case .apiError(let error),
       .geocodeError(let error):
    state.error = error
    return .none
  }
}

// MARK: - View

struct CurrentWeatherRow: View {
  let title: String
  let detail: String

  var body: some View {
    HStack {
      Text("\(title):")
        .font(.headline)
      Text(detail)
        .font(.caption)
      Spacer()
    }
    .frame(minHeight: 36)
  }
}

public struct FullForecastView: View {
  let store: Store<FullForecastState, FullForecastAction>

  public init(store: Store<FullForecastState, FullForecastAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewState in
      VStack(alignment: .center, spacing: 16) {
        if let error = viewState.error {
          Text(verbatim: error)
            .foregroundColor(.red)
        } else {
          VStack(alignment: .leading, spacing: 16) {
            Text("Daily Forecast")
              .font(.largeTitle)
              .padding([.leading, .trailing], 16)
            if let forecast = viewState.forecast {
              DailyForecastView(
                days: forecast.daily,
                timeZone: TimeZone(identifier: forecast.timezone) ?? TimeZone(secondsFromGMT: forecast.timezoneOffset) ?? .autoupdatingCurrent
              )
            } else {
              DailyForecastView(
                days: OneCallForecastResponse.mock.daily,
                timeZone: .current
              )
            }

            Text("Hourly Forecast")
              .font(.largeTitle)
              .padding([.leading, .trailing], 16)
            if let forecast = viewState.forecast {
              HourlyForecastView(
                forecast: forecast.hourly,
                timeZone: TimeZone(identifier: forecast.timezone) ?? TimeZone(secondsFromGMT: forecast.timezoneOffset) ?? .autoupdatingCurrent
              )
              .padding([.leading, .trailing], 16)
            } else {
              HourlyForecastView(
                forecast: (0..<3).map { i in
                  return Current(
                    dt: 0,
                    temp: 239,
                    pressure: 1020,
                    humidity: 30,
                    dewPoint: 239,
                    windSpeed: 10,
                    windDeg: 3,
                    weather: [
                      Weather(id: 801, main: .clouds)
                    ]
                  )
                },
                timeZone: .current
              )
              .padding([.leading, .trailing], 16)
            }
          }
          .redacted(reason: viewState.forecast == nil ? .placeholder : [])
        }
      }
    }
  }
}

struct FullForecastView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FullForecastView(
        store: .init(
          initialState: .init(coord: CLLocationCoordinate2D(latitude: 40.71, longitude: 74)),
          reducer: fullForecastReducer,
          environment: .mock
        )
      )
      FullForecastView(
        store: .init(
          initialState: .init(coord: CLLocationCoordinate2D(latitude: 40.71, longitude: 74)),
          reducer: fullForecastReducer,
          environment: .failing
        )
      )
    }
  }
}

// MARK: - Utilities

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
