import Combine
import ComposableArchitecture
import CoreLocation
@testable import FullForecast
import Geocoder
import OpenWeatherAPI
import XCTest

final class FullForecastTests: XCTestCase {
  func testSetQuery() {
    let store = TestStore(
      initialState: .init(),
      reducer: fullForecastReducer,
      environment: .init(
        api: .mock,
        geocoder: .mock
      )
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.geocodeSuccess(.mock)) {
        $0.coord = .mock
      },
      .receive(.apiResponse(.mock)) {
        $0.forecast = .mock
      }
    )
  }

  func testReset() {
    let store = TestStore(
      initialState: .init(),
      reducer: fullForecastReducer,
      environment: .init(
        api: .mock,
        geocoder: .mock
      )
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.geocodeSuccess(.mock)) {
        $0.coord = .mock
      },
      .receive(.apiResponse(.mock)) {
        $0.forecast = .mock
      },
      .send(.reset) {
        $0.query = nil
        $0.coord = nil
        $0.forecast = nil
        $0.error = nil
      }
    )
  }

  func testGeocodeError() {
    let error = "The operation couldn’t be completed. (Geocoder.GeocoderError error 2.)"
    let store = TestStore(
      initialState: .init(),
      reducer: fullForecastReducer,
      environment: .init(
        api: .mock,
        geocoder: .failing
      )
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.geocodeError(error)) {
        $0.error = error
      }
    )
  }

  func testAPIError() {
    let error = "The operation couldn’t be completed. (OpenWeatherAPI.OpenWeatherAPIError error 0.)"
    let store = TestStore(
      initialState: .init(),
      reducer: fullForecastReducer,
      environment: .init(
        api: .failing,
        geocoder: .mock
      )
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.geocodeSuccess(.mock)) {
        $0.coord = .mock
      },
      .receive(.apiError(error)) {
        $0.error = error
      }
    )
  }
}
