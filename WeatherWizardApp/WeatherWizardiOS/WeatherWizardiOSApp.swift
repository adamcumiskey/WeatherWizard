import WeatherWizard
import SwiftUI

@main
struct WeatherWizardMacOSApp: App {
  var body: some Scene {
    WindowGroup {
      WeatherWizardView(
        store: .init(
          initialState: .init(),
          reducer: weatherWizardReducer,
          environment: .live
        )
      )
    }
  }
}
