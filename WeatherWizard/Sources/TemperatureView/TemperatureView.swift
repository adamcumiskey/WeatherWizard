import Formatter
import SwiftUI

public struct TemperatureView: View {
  public struct Size {
    let currentTempFontSize: CGFloat
    let highLowFontSize: CGFloat
    let currentToHighLowSpacing: CGFloat
    let highToLowSpacing: CGFloat

    public static var small: Size {
      return .init(
        currentTempFontSize: 20,
        highLowFontSize: 12,
        currentToHighLowSpacing: 4,
        highToLowSpacing: 2
      )
    }

    public static var medium: Size {
      return .init(
        currentTempFontSize: 32,
        highLowFontSize: 16,
        currentToHighLowSpacing: 8,
        highToLowSpacing: 4
      )
    }

    public static var large: Size {
      return .init(
        currentTempFontSize: 72,
        highLowFontSize: 24,
        currentToHighLowSpacing: 16,
        highToLowSpacing: 6
      )
    }
  }

  let size: Size
  let current: Double
  let high: Double
  let low: Double
  public init(size: TemperatureView.Size, current: Double, high: Double, low: Double) {
    self.size = size
    self.current = current
    self.high = high
    self.low = low
  }

  public var body: some View {
    HStack(alignment: .center, spacing: size.currentToHighLowSpacing) {
      Text(verbatim: .temperatureString(current))
        .bold()
        .font(.system(size: size.currentTempFontSize))
        .lineLimit(1)
      VStack(alignment: .trailing, spacing: size.highToLowSpacing) {
        HStack {
          Text(verbatim: .temperatureString(high))
            .font(.system(size: size.highLowFontSize))
            .lineLimit(1)
          Image(systemName: "arrow.up.square.fill")
            .foregroundColor(.orange)
            .font(.system(size: size.highLowFontSize))
        }
        HStack {
          Text(verbatim: .temperatureString(low))
            .font(.system(size: size.highLowFontSize))
            .lineLimit(1)
          Image(systemName: "arrow.down.square.fill")
            .foregroundColor(.blue)
            .font(.system(size: size.highLowFontSize))
        }
      }
    }
  }
}

struct TemperatureView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TemperatureView(size: .large, current: 293, high: 295, low: 290)
      TemperatureView(size: .small, current: 293, high: 295, low: 290)
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
