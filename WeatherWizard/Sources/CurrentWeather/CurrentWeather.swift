import Combine
import ComposableArchitecture
import Formatter
import OpenWeatherAPI
import TemperatureView
import SwiftUI

// MARK: - State

public struct CurrentWeatherState: Equatable {
  public var query: String?
  public var currentWeather: CurrentWeatherResponse?
  public var error: String?

  public init(query: String? = nil, currentWeather: CurrentWeatherResponse? = nil, error: String? = nil) {
    self.query = query
    self.currentWeather = currentWeather
    self.error = error
  }
}

// MARK: - Action

public enum CurrentWeatherAction: Equatable {
  case reset
  case setQuery(String)
  case apiResponse(CurrentWeatherResponse)
  case apiError(String)
}

// MARK: - Environment

public struct CurrentWeatherEnvironment {
  let api: OpenWeatherAPI
  public init(api: OpenWeatherAPI) {
    self.api = api
  }

  public static var live: CurrentWeatherEnvironment {
    return .init(api: .live)
  }

  public static var mock: CurrentWeatherEnvironment {
    return .init(api: .mock)
  }

  public static var failing: CurrentWeatherEnvironment {
    return .init(api: .failing)
  }
}

// MARK: - Reducer

public let currentWeatherReducer = Reducer<CurrentWeatherState, CurrentWeatherAction, CurrentWeatherEnvironment> { state, action, env in
  switch action {
  case .reset:
    state.query = nil
    state.currentWeather = nil
    state.error = nil
    return .none
  case .setQuery(let query):
    state.query = query
    state.currentWeather = nil
    guard !query.isEmpty else {
      state.error = nil
      return .none
    }
    return Effect(env.api.getCurrentWeather(query))
      .catchToEffect()
      .map { result in
        switch result {
        case .success(let currentWeather):
          return .apiResponse(currentWeather)
        case .failure(let error):
          return .apiError(error.localizedDescription)
        }
      }
      .eraseToEffect()
  case let .apiResponse(currentWeather):
    state.currentWeather = currentWeather
    return .none
  case let .apiError(error):
    state.currentWeather = nil
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
        .font(.subheadline)
      Spacer()
    }
    .frame(minHeight: 36)
  }
}

public struct CurrentWeatherView: View {
  let store: Store<CurrentWeatherState, CurrentWeatherAction>
  public init(store: Store<CurrentWeatherState, CurrentWeatherAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        if let error = viewStore.state.error {
          VStack(spacing: 16) {
            Text(verbatim: error)
              .font(.caption)
              .foregroundColor(.red)
          }
        } else {
          VStack(alignment: .leading, spacing: 8) {
            Text("Current Weather for \(viewStore.currentWeather?.name ?? "        ")")
              .font(.largeTitle)
            if let weather = viewStore.state.currentWeather?.weather.first {
              weather.image
                .font(.system(size: 72))
            }
            if let currentWeather = viewStore.state.currentWeather?.main {
              TemperatureView(
                size: .large,
                current: currentWeather.temp,
                high: currentWeather.tempMax,
                low: currentWeather.tempMin
              )
              LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
              ], alignment: .leading, spacing: 16, pinnedViews: [], content: {
                VStack {
                  PressureView(pressure: Double(currentWeather.pressure))
                  Text("Pressure").font(.caption)
                }
                VStack {
                  HumidityView(humidity: currentWeather.humidity)
                  Text("Humidity").font(.caption)
                }
              })
            } else {
              TemperatureView(
                size: .large,
                current: 290,
                high: 290,
                low: 290
              )
              LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
              ], alignment: .leading, spacing: 16, pinnedViews: [], content: {
                VStack {
                  PressureView(pressure: Double(1006))
                  Text("Pressure").font(.caption)
                }
                VStack {
                  HumidityView(humidity: 30)
                  Text("Humidity").font(.caption)
                }
              })            }
          }
          .redacted(reason: viewStore.state.currentWeather == nil ? .placeholder : [])
        }
      }
      .padding()
      .onAppear {
        if let query = viewStore.state.query {
          viewStore.send(.setQuery(query))
        }
      }
    }
  }
}

struct CurrentWeatherView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CurrentWeatherView(
        store: .init(
          initialState: .init(query: "Pocono Pines, Pennsylvania"),
          reducer: currentWeatherReducer,
          environment: .init(api: .mock)
        )
      )
      CurrentWeatherView(
        store: .init(
          initialState: .init(),
          reducer: currentWeatherReducer,
          environment: .init(api: .mock)
        )
      )
      CurrentWeatherView(
        store: .init(
          initialState: .init(query: "sdfgqwj"),
          reducer: currentWeatherReducer,
          environment: .init(api: .failing)
        )
      )

    }
    .previewLayout(.device)
  }
}
