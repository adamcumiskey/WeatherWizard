import Formatter
import OpenWeatherAPI
import SwiftUI

struct HourItemView: View {
  let title: String
  let detail: String

  var body: some View {
    VStack {
      Text("\(title):")
        .font(.headline)
        .lineLimit(1)
      Text(detail)
        .font(.subheadline)
        .lineLimit(1)
    }
  }
}

struct HourView: View {
  let timeZone: TimeZone
  let hour: Current

  var body: some View {
    HStack(spacing: 16) {
      VStack {
        hour.weather[0].image
        Text(
          verbatim: .hourString(
            Date(timeIntervalSince1970: TimeInterval(hour.dt)),
            timeZone: timeZone
          )
        ).font(.title2)
        .lineLimit(1)
      }
      HourItemView(
        title: "Temp",
        detail: .temperatureString(hour.temp)
      )
      HourItemView(
        title: "Dew Point",
        detail: .temperatureString(hour.dewPoint)
      )
      if let windspeed = hour.windSpeed {
        HourItemView(
          title: "Wind Speed",
          detail: .speedString(windspeed)
        )
      }
    }.frame(minHeight: 36)
  }
}

public struct HourlyForecastView: View {
  let forecast: [Current]
  let timeZone: TimeZone
  public init(forecast: [Current], timeZone: TimeZone) {
    self.forecast = forecast
    self.timeZone = timeZone
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      ForEach(forecast, id: \.dt) { hour in
        HourView(timeZone: timeZone, hour: hour)
        Divider()
      }
    }
  }
}
