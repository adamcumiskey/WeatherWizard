import ComposableArchitecture
@testable import LocationSearch
import SnapshotTesting
import SwiftUI
import XCTest

final class LocationSearchTests: XCTestCase {
  func testEnteringSearchText() {
    let store = TestStore(
      initialState: LocationSearchState(searchText: ""),
      reducer: locationSearchReducer,
      environment: LocationSearchEnvironment.mock
    )

    store.assert(
      .send(.editSearchText("Pocono")) {
        $0.searchText = "Pocono"
      },
      .send(.editSearchText("Pocono Pines")) {
        $0.searchText = "Pocono Pines"
      }
    )
  }
}
