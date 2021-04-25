import Combine
import ComposableArchitecture
import CoreLocation
import CurrentWeather
import FullForecast
import Geocoder
import LocationSearch
import SwiftUI
import Wizard
import WizardButton
import WizardSelection
import WizardStorage

// MARK: - State

public struct WeatherWizardState: Equatable {
  public var locationSearch: LocationSearchState
  public var currentWeather: CurrentWeatherState
  public var fullForecast: FullForecastState
  public var wizardButton: WizardButtonState
  public var wizardSelection: WizardSelectionState
  public var isShowingWizardSelection: Bool = false

  public var isFullForecastViewHidden: Bool {
    return !(currentWeather.error == nil && fullForecast.error == nil)
  }
  
  public init(locationSearch: LocationSearchState = .init(),
              currentWeather: CurrentWeatherState = .init(),
              fullForecast: FullForecastState = .init(),
              wizardSelection: WizardSelectionState = .init(),
              wizardButton: WizardButtonState = .init()) {
    self.locationSearch = locationSearch
    self.currentWeather = currentWeather
    self.fullForecast = fullForecast
    self.wizardSelection = wizardSelection
    self.wizardButton = wizardButton
  }
}

// MARK: - Action

public enum WeatherWizardAction: Equatable {
  case locationSearch(LocationSearchAction)
  case currentWeather(CurrentWeatherAction)
  case fullForecast(FullForecastAction)
  case wizardButton(WizardButtonAction)
  case wizardSelection(WizardSelectionAction)

  case setIsShowingWizardSelection(Bool)
}

// MARK: - Environment

public struct WeatherWizardEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let locationSearchEnvironment: LocationSearchEnvironment
  let currentWeatherEnvironment: CurrentWeatherEnvironment
  let fullForecastEnvironment: FullForecastEnvironment
  let wizardSelectionEnvironment: WizardSelectionEnvironment
  let wizardStorage: WizardStorage

  public init(mainQueue: AnySchedulerOf<DispatchQueue>,
              locationSearchEnvironment: LocationSearchEnvironment,
              currentWeatherEnvironment: CurrentWeatherEnvironment,
              fullForecastEnvironment: FullForecastEnvironment,
              wizardSelectionEnvironment: WizardSelectionEnvironment,
              wizardStorage: WizardStorage) {
    self.mainQueue = mainQueue
    self.locationSearchEnvironment = locationSearchEnvironment
    self.currentWeatherEnvironment = currentWeatherEnvironment
    self.fullForecastEnvironment = fullForecastEnvironment
    self.wizardSelectionEnvironment = wizardSelectionEnvironment
    self.wizardStorage = wizardStorage
  }

  public static var live: WeatherWizardEnvironment {
    return .init(
      mainQueue: .main,
      locationSearchEnvironment: .live,
      currentWeatherEnvironment: .live,
      fullForecastEnvironment: .live,
      wizardSelectionEnvironment: .live,
      wizardStorage: .live
    )
  }

  public static var mock: WeatherWizardEnvironment {
    return .init(
      mainQueue: .immediate,
      locationSearchEnvironment: .mock,
      currentWeatherEnvironment: .mock,
      fullForecastEnvironment: .mock,
      wizardSelectionEnvironment: .mock,
      wizardStorage: .mock
    )
  }

  public static var failing: WeatherWizardEnvironment {
    return .init(
      mainQueue: .immediate,
      locationSearchEnvironment: .failing,
      currentWeatherEnvironment: .failing,
      fullForecastEnvironment: .failing,
      wizardSelectionEnvironment: .mock,
      wizardStorage: .mock
    )
  }
}

// MARK: - Reducer

public let weatherWizardReducer = Reducer<WeatherWizardState, WeatherWizardAction, WeatherWizardEnvironment>.combine(
  locationSearchReducer.pullback(
    state: \.locationSearch,
    action: /WeatherWizardAction.locationSearch,
    environment: { $0.locationSearchEnvironment }
  ),
  currentWeatherReducer.pullback(
    state: \.currentWeather,
    action: /WeatherWizardAction.currentWeather,
    environment: { $0.currentWeatherEnvironment }
  ),
  fullForecastReducer.pullback(
    state: \.fullForecast,
    action: /WeatherWizardAction.fullForecast,
    environment: { $0.fullForecastEnvironment }
  ),
  wizardSelectionReducer.pullback(
    state: \.wizardSelection,
    action: /WeatherWizardAction.wizardSelection,
    environment: { $0.wizardSelectionEnvironment }
  ),
  wizardButtonReducer.pullback(
    state: \.wizardButton,
    action: /WeatherWizardAction.wizardButton,
    environment: { WizardButtonEnvironment(storage: $0.wizardStorage) }
  ),
  Reducer { state, action, env in
    struct LocationQueryID: Hashable {}
    switch action {
    case .locationSearch(let action):
      switch action {
      case .editSearchText(let searchText):
        if !searchText.isEmpty {
          return Effect.concatenate(
            Effect(value: .currentWeather(.setQuery(searchText))),
            Effect(value: .fullForecast(.setQuery(searchText)))
          )
          .debounce(id: LocationQueryID(), for: 1.0, scheduler: env.mainQueue)
          .eraseToEffect()
        }
        fallthrough
      case .clear:
        return .concatenate(
          Effect.cancel(id: LocationQueryID()),
          Effect(value: .currentWeather(.reset)),
          Effect(value: .fullForecast(.reset))
        )
      }
    case .currentWeather(let action):
      switch action {
      case .apiError:
        return Effect.concatenate(Effect.cancel(id: LocationQueryID()))
      default:
        return .none
      }
    case .fullForecast(let action):
      switch action {
      case .apiError:
        return Effect.concatenate(Effect.cancel(id: LocationQueryID()))
      default:
        return .none
      }
    case .wizardButton(let action):
      switch action {
      case .onTap:
        return Effect(value: .setIsShowingWizardSelection(true))
      default:
        return .none
      }
    case .wizardSelection(let action):
      switch action {
      case .selectWizard(let wizard):
        return Effect(value: .wizardButton(.setWizard(wizard)))
      default:
        return .none
      }
    case .setIsShowingWizardSelection(let isShowing):
      state.isShowingWizardSelection = isShowing
      return .none
    }
  }
)

// MARK: - View

public struct WeatherWizardView: View {
  let store: Store<WeatherWizardState, WeatherWizardAction>
  public init(store: Store<WeatherWizardState, WeatherWizardAction>) {
    self.store = store
  }

  private func mainView(_ viewStore: ViewStore<WeatherWizardState, WeatherWizardAction>) -> some View {
    ScrollView {
      LocationSearchView(
        store: store.scope(
          state: { $0.locationSearch },
          action: { .locationSearch($0) }
        )
      )
      Divider()
      if !viewStore.state.locationSearch.searchText.isEmpty {
        CurrentWeatherView(
          store: store.scope(
            state: { $0.currentWeather },
            action: { .currentWeather($0) }
          )
        )
        if !viewStore.state.isFullForecastViewHidden {
          Divider()
          FullForecastView(
            store: store.scope(
              state: { $0.fullForecast },
              action: { .fullForecast($0) }
            )
          )
        }
      } else {
        Text("Enter a city name to get the latest forecast")
          .font(.caption)
          .foregroundColor(.gray)
          .padding()
      }
    }
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      #if os(iOS)
      NavigationView {
        mainView(viewStore)
          .navigationTitle("WeatherWizard")
          .navigationBarItems(
            trailing: WizardButton(
              store: self.store.scope(
                state: \.wizardButton,
                action: { .wizardButton($0) }
              )
            )
          )
          .sheet(
            isPresented: viewStore.binding(
              get: \.isShowingWizardSelection,
              send: { WeatherWizardAction.setIsShowingWizardSelection($0) }
            )
          ) {
            WizardSelectionView(
              store: self.store.scope(
                state: \.wizardSelection,
                action: { .wizardSelection($0) }
              )
            )
          }
      }
      #elseif os(macOS)
      mainView(viewStore)
      #endif
    }
  }
}

struct WeatherWizardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WeatherWizardView(
        store: .init(
          initialState: .init(),
          reducer: weatherWizardReducer,
          environment: .mock
        )
      )
      WeatherWizardView(
        store: .init(
          initialState: .init(locationSearch: .init(searchText: "T")),
          reducer: weatherWizardReducer,
          environment: .failing
        )
      )
    }.padding()
  }
}
