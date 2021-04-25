import ComposableArchitecture
import SwiftUI

// MARK: - State

public struct LocationSearchState: Equatable {
//  public var wizardButtonState: WizardButtonState
  public var searchText: String
  public init(searchText: String = "") {
    self.searchText = searchText
  }
}

// MARK: - Action

public enum LocationSearchAction: Equatable {
  case editSearchText(String)
  case clear
}

public struct LocationSearchEnvironment {
  public init() {}

  public static var live: LocationSearchEnvironment {
    return .init()
  }

  public static var mock: LocationSearchEnvironment {
    return .init()
  }

  public static var failing: LocationSearchEnvironment {
    return .init()
  }
}

public let locationSearchReducer = Reducer<LocationSearchState, LocationSearchAction, LocationSearchEnvironment> { state, action, env in
  switch action {
  case .editSearchText(let newText):
    state.searchText = newText
    return .none
  case .clear:
    state.searchText = ""
    return .none
  }
}

public struct LocationSearchView: View {
  let store: Store<LocationSearchState, LocationSearchAction>

  public init(store: Store<LocationSearchState, LocationSearchAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        TextField(
          "Enter City Name",
          text: viewStore.binding(
            get: { $0.searchText },
            send: { .editSearchText($0) }
          )
        ).textFieldStyle(RoundedBorderTextFieldStyle())
        if !viewStore.state.searchText.isEmpty {
          Button {
            viewStore.send(.clear)
          } label: {
            Image(systemName: "xmark.circle.fill")
          }
          .foregroundColor(.secondary)
          .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
        }
      }
      .animation(.default)
      .padding()
      .onAppear {
        // Send an initial edit event for any pre-populated search queries
        viewStore.send(.editSearchText(viewStore.state.searchText))
      }
    }
  }
}

struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LocationSearchView(
        store: .init(
          initialState: .init(),
          reducer: locationSearchReducer,
          environment: .mock
        )
      )
      LocationSearchView(
        store: .init(
          initialState: .init(searchText: "Wokingham, UK"),
          reducer: locationSearchReducer,
          environment: .mock
        )
      )
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
