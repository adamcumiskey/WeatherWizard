import ComposableArchitecture
import SwiftUI
import Wizard
import WizardStorage

public struct WizardButtonState: Identifiable, Equatable {
  public var id: String { wizard?.rawValue ?? UUID().uuidString }
  public var wizard: Wizard?
  public var isSelected: Bool
  public init(wizard: Wizard? = nil, isSelected: Bool = false) {
    self.wizard = wizard
    self.isSelected = isSelected
  }
}

public enum WizardButtonAction: Equatable {
  case loadDefaultWizard
  case onTap
  case setWizard(Wizard)
  case setSelected(Bool)
}

public struct WizardButtonEnvironment {
  let storage: WizardStorage

  public init(storage: WizardStorage) {
    self.storage = storage
  }

  static var live: WizardButtonEnvironment {
    .init(storage: .live)
  }

  static var mock: WizardButtonEnvironment {
    .init(storage: .mock)
  }
}

public let wizardButtonReducer = Reducer<WizardButtonState, WizardButtonAction, WizardButtonEnvironment> { state, action, env in
  switch action {
  case .loadDefaultWizard:
    return Effect(value: .setWizard(env.storage.getWizard()))
  case .onTap:
    return .none
  case .setWizard(let newWizard):
    state.wizard = newWizard
    return .none
  case .setSelected(let isSelected):
    state.isSelected = true
    return .none
  }
}


public struct WizardButton: View {
  let store: Store<WizardButtonState, WizardButtonAction>

  public init(store: Store<WizardButtonState, WizardButtonAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Circle()
          .fill(viewStore.state.isSelected ? Color.accentColor.opacity(0.8) : Color.clear)
        Button {
          viewStore.send(.onTap)
        } label: {
          let buttonText = viewStore.state.wizard?.rawValue ?? "🔮"
          Text(buttonText)
            .font(.largeTitle)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(8)
      }
      .onAppear {
        if viewStore.wizard == nil {
          viewStore.send(.loadDefaultWizard)
        }
      }
    }
  }
}

struct WizardButton_Preview: PreviewProvider {
  static var previews: some View {
    Group {
      ForEach((0..<5)) { _ in
        WizardButton(
          store: .init(
            initialState: .init(wizard: .random),
            reducer: wizardButtonReducer,
            environment: .mock
          )
        )
      }
      WizardButton(
        store: .init(
          initialState: .init(wizard: .random, isSelected: true),
          reducer: wizardButtonReducer,
          environment: .mock
        )
      )
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
