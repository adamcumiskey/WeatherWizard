//
//  WeatherWizardAppApp.swift
//  WeatherWizardApp
//
//  Created by adam.cumiskey on 4/24/21.
//

import CurrentWeather
import OpenWeatherAPI
import SwiftUI

@main
struct WeatherWizardApp: App {
  var body: some Scene {
    WindowGroup {
      CurrentWeatherView(
        store: .init(
          initialState: .init(location: .cityAndState("Pocono Pines", "Pennsylvania")),
          reducer: currentWeatherReducer.debug(),
          environment: CurrentWeatherEnvironment(
            api: OpenWeatherAPI(
              apiKey: ProcessInfo.processInfo.environment["OPEN_WEATHER_API_KEY"]!
            )
          )
        )
      ).padding()
    }
  }
}
