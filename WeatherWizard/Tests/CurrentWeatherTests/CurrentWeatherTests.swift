import Combine
import ComposableArchitecture
@testable import CurrentWeather
import XCTest

final class CurrentWeatherTests: XCTestCase {
  func testSetQuery() {
    let store = TestStore(
      initialState: .init(),
      reducer: currentWeatherReducer,
      environment: .mock
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.apiResponse(.mock)) {
        $0.currentWeather = .mock
      }
    )
  }

  func testReset() {
    let store = TestStore(
      initialState: .init(),
      reducer: currentWeatherReducer,
      environment: .mock
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.apiResponse(.mock)) {
        $0.currentWeather = .mock
      },
      .send(.reset) {
        $0.query = nil
        $0.currentWeather = nil
        $0.error = nil
      }
    )
  }

  func testApiError() {
    let error = "The operation couldn’t be completed. (OpenWeatherAPI.OpenWeatherAPIError error 0.)"
    let store = TestStore(
      initialState: .init(),
      reducer: currentWeatherReducer,
      environment: .failing
    )

    store.assert(
      .send(.setQuery("London")) {
        $0.query = "London"
      },
      .receive(.apiError(error)) {
        $0.error = error
      }
    )
  }
}
