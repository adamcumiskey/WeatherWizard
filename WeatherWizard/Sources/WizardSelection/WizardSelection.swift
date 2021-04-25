import ComposableArchitecture
import SwiftUI
import Wizard
import WizardButton
import WizardStorage

public struct WizardSelectionState: Equatable {
  public var selectedWizard: Wizard?
  public var wizardButtons: [WizardButtonState]

  public init(wizardButtons: [WizardButtonState] = Wizard.allCases.map { .init(wizard: $0) }) {
    self.wizardButtons = wizardButtons
  }
}

public enum WizardSelectionAction: Equatable {
  case loadSelectedWizard
  case selectWizard(Wizard)
  case wizardButton(index: Int, action: WizardButtonAction)
}

public struct WizardSelectionEnvironment {
  var storage: WizardStorage

  public init(storage: WizardStorage) {
    self.storage = storage
  }

  public static var live: WizardSelectionEnvironment {
    return .init(storage: .live)
  }

  public static var mock: WizardSelectionEnvironment {
    return .init(storage: .mock)
  }
}

public let wizardSelectionReducer = Reducer<WizardSelectionState, WizardSelectionAction, WizardSelectionEnvironment>.combine(
  Reducer<WizardSelectionState, WizardSelectionAction, WizardSelectionEnvironment> { state, action, env in
    switch action {
    case .loadSelectedWizard:
      let wizard = env.storage.getWizard()
      return Effect(value: .selectWizard(wizard))
    case let .selectWizard(wizard):
      state.selectedWizard = wizard
      guard let index = state.wizardButtons.map({ $0.wizard }).firstIndex(of: wizard) else {
        return .none
      }
      return Effect.concatenate(
        Effect(value: .wizardButton(index: index, action: .setSelected(true))),
        Effect.fireAndForget {
          env.storage.setWizard(wizard)
        }
      )
    case let .wizardButton(index, action):
      switch action {
      case .onTap:
        state.wizardButtons = state.wizardButtons.map { WizardButtonState(wizard: $0.wizard) }
        guard let wizard = state.wizardButtons[index].wizard else { return .none }
        return Effect(value: .selectWizard(wizard))
      default:
        return .none
      }
    }
  },
  wizardButtonReducer.forEach(
    state: \WizardSelectionState.wizardButtons,
    action: /WizardSelectionAction.wizardButton(index:action:),
    environment: { WizardButtonEnvironment(storage: $0.storage) }
  )
)

public struct WizardSelectionView: View {
  let store: Store<WizardSelectionState, WizardSelectionAction>

  public init(store: Store<WizardSelectionState, WizardSelectionAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        LazyHGrid(
          rows: [
            GridItem(.flexible(minimum: 80, maximum: 80), spacing: 16, alignment: .center),
            GridItem(.flexible(minimum: 80, maximum: 80), spacing: 16, alignment: .center),
            GridItem(.flexible(minimum: 80, maximum: 80), spacing: 16, alignment: .center),
          ]
        ) {
          Section {
            ForEachStore(
              self.store.scope(state: \.wizardButtons, action: WizardSelectionAction.wizardButton(index:action:)),
              content: WizardButton.init(store:)
            )
          }
        }
        Text("Choose Your Wizard")
          .font(.caption)
        Spacer()
      }.onAppear {
        viewStore.send(.loadSelectedWizard)
      }
    }
  }
}

public struct WizardSelectionView_Previews: PreviewProvider {
  public static var previews: some View {
    Group {
      WizardSelectionView(
        store: .init(
          initialState: .init(),
          reducer: wizardSelectionReducer,
          environment: .mock
        )
      )
    }.padding()
  }
}
