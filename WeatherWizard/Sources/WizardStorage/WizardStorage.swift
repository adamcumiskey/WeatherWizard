import Combine
import Foundation
import Wizard

public struct WizardStorage {
  public let getWizard: () -> Wizard
  public let setWizard: (Wizard) -> ()
}

public extension WizardStorage {
  static var live: WizardStorage {
    let userDefaults = UserDefaults.standard
    let key = "weatherwizard.storage.selected-wizard"
    return .init(
      getWizard: {
        guard let rawWizard = userDefaults.string(forKey: key),
              let wizard = Wizard(rawValue: rawWizard) else {
          return .random
        }
        return wizard
      },
      setWizard: { userDefaults.set($0.rawValue, forKey: key) }
    )
  }

  static var mock: WizardStorage {
    var wizard: Wizard = .female3
    return .init(
      getWizard: { wizard },
      setWizard: { newWizard in wizard = newWizard }
    )
  }
}
