import Formatter
import OpenWeatherAPI
import TemperatureView
import SwiftUI

struct DailyForecastView: View {
  let days: [Daily]
  let timeZone: TimeZone

  #if os(iOS)
  let rows: [GridItem] = [.init(.flexible())]
  #elseif os(macOS)
  let rows: [GridItem] = [.init(.adaptive(minimum: 120))]
  #endif

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: rows) {
        ForEach(days, id: \.dt) { day in
          VStack(spacing: 8) {
            Text(
              verbatim: .shortDateString(
                Date(timeIntervalSince1970: Double(day.dt!)),
                timeZone: timeZone
              )
            )
            .font(.headline)
            day.weather[0].image
              .font(.system(size: 42))
              .frame(width: 50, height: 50)
            TemperatureView(
              size: .small,
              current: day.temp!.day!,
              high: day.temp!.max!,
              low: day.temp!.min!
            ).frame(minWidth: 120)
          }
        }
      }
      .frame(maxHeight: 130)
    }
  }
}

struct DailyForecastView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DailyForecastView(days: OneCallForecastResponse.mock.daily, timeZone: .current)
    }.previewLayout(.sizeThatFits)
  }
}
