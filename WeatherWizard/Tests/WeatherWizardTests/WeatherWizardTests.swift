import ComposableArchitecture
@testable import WeatherWizard
import SnapshotTesting
import SwiftUI
import XCTest

final class WeatherWizardTests: XCTestCase {
  func testSearchAndClear() {
    let query = "London"
    let store = TestStore(
      initialState: WeatherWizardState(),
      reducer: weatherWizardReducer,
      environment: .mock
    )

    store.assert(
      // Search
      .send(.locationSearch(.editSearchText(query))) {
        $0.locationSearch.searchText = query
      },
      .receive(.currentWeather(.setQuery(query))) {
        $0.currentWeather.query = query
      },
      .receive(.fullForecast(.setQuery(query))) {
        $0.fullForecast.query = query
      },
      .receive(.currentWeather(.apiResponse(.mock))) {
        $0.currentWeather.currentWeather = .mock
      },
      .receive(.fullForecast(.geocodeSuccess(.mock))) {
        $0.fullForecast.coord = .mock
      },
      .receive(.fullForecast(.apiResponse(.mock))) {
        $0.fullForecast.forecast = .mock
      },

      // Clear
      .send(.locationSearch(.editSearchText(""))) {
        $0.locationSearch.searchText = ""
      },
      .receive(.currentWeather(.reset)) {
        $0.currentWeather.query = nil
        $0.currentWeather.currentWeather = nil
      },
      .receive(.fullForecast(.reset)) {
        $0.fullForecast.query = nil
        $0.fullForecast.coord = nil
        $0.fullForecast.forecast = nil
      }
    )
  }

  func testFailingSearchAPI() {
    let query = "London"
    let error = "The operation couldn’t be completed. (OpenWeatherAPI.OpenWeatherAPIError error 0.)"
    let store = TestStore(
      initialState: .init(),
      reducer: weatherWizardReducer,
      environment: .init(
        mainQueue: .immediate,
        locationSearchEnvironment: .mock,
        currentWeatherEnvironment: .failing,
        fullForecastEnvironment: .init(api: .failing, geocoder: .mock),
        wizardSelectionEnvironment: .mock,
        wizardStorage: .mock
      )
    )

    store.assert(
      .send(.locationSearch(.editSearchText(query))) {
        $0.locationSearch.searchText = query
      },
      .receive(.currentWeather(.setQuery(query))) {
        $0.currentWeather.query = query
      },
      .receive(.fullForecast(.setQuery(query))) {
        $0.fullForecast.query = query
      },
      .receive(.currentWeather(.apiError(error))) {
        $0.currentWeather.error = error
      },
      .receive(.fullForecast(.geocodeSuccess(.mock))) {
        $0.fullForecast.coord = .mock
      },
      .receive(.fullForecast(.apiError(error))) {
        $0.fullForecast.error = error
      }
    )
  }

  func testFailingGeocoder() {
    let query = "London"
    let error = "The operation couldn’t be completed. (Geocoder.GeocoderError error 2.)"
    let store = TestStore(
      initialState: .init(),
      reducer: weatherWizardReducer,
      environment: .init(
        mainQueue: .immediate,
        locationSearchEnvironment: .mock,
        currentWeatherEnvironment: .mock,
        fullForecastEnvironment: .init(api: .mock, geocoder: .failing),
        wizardSelectionEnvironment: .mock,
        wizardStorage: .mock
      )
    )

    store.assert(
      .send(.locationSearch(.editSearchText(query))) {
        $0.locationSearch.searchText = query
      },
      .receive(.currentWeather(.setQuery(query))) {
        $0.currentWeather.query = query
      },
      .receive(.fullForecast(.setQuery(query))) {
        $0.fullForecast.query = query
      },
      .receive(.currentWeather(.apiResponse(.mock))) {
        $0.currentWeather.currentWeather = .mock
      },
      .receive(.fullForecast(.geocodeError(error))) {
        $0.fullForecast.error = error
      }
    )
  }

  func testFailingQueryThenSuccessfulQuery() {
    let query = "London"
    let error = "The operation couldn’t be completed. (OpenWeatherAPI.OpenWeatherAPIError error 0.)"
    let store = TestStore(
      initialState: .init(),
      reducer: weatherWizardReducer,
      environment: .init(
        mainQueue: .immediate,
        locationSearchEnvironment: .mock,
        currentWeatherEnvironment: .failing,
        fullForecastEnvironment: .init(api: .failing, geocoder: .mock),
        wizardSelectionEnvironment: .mock,
        wizardStorage: .mock
      )
    )

    store.assert(
      .send(.locationSearch(.editSearchText(query))) {
        $0.locationSearch.searchText = query
      },
      .receive(.currentWeather(.setQuery(query))) {
        $0.currentWeather.query = query
      },
      .receive(.fullForecast(.setQuery(query))) {
        $0.fullForecast.query = query
      },
      .receive(.currentWeather(.apiError(error))) {
        $0.currentWeather.error = error
      },
      .receive(.fullForecast(.geocodeSuccess(.mock))) {
        $0.fullForecast.coord = .mock
      },
      .receive(.fullForecast(.apiError(error))) {
        $0.fullForecast.error = error
      },

      // fix env
      .do {
        store.environment = .mock
      },

      // new query
      .send(.locationSearch(.editSearchText(query))) {
        $0.locationSearch.searchText = query
      },
      .receive(.currentWeather(.setQuery(query))) {
        $0.currentWeather.query = query
      },
      .receive(.fullForecast(.setQuery(query))) {
        $0.fullForecast.query = query
      },
      .receive(.currentWeather(.apiResponse(.mock))) {
        $0.currentWeather.currentWeather = .mock
      },
      .receive(.fullForecast(.geocodeSuccess(.mock))) {
        $0.fullForecast.coord = .mock
      },
      .receive(.fullForecast(.apiResponse(.mock))) {
        $0.fullForecast.forecast = .mock
      }
    )
  }

  func testWizardButtonTap() {
    let store = TestStore(
      initialState: WeatherWizardState(),
      reducer: weatherWizardReducer,
      environment: .mock
    )

    store.assert(
      .send(.wizardButton(.onTap)),
      .receive(.setIsShowingWizardSelection(true)) {
        $0.isShowingWizardSelection = true
      }
    )
  }
}
