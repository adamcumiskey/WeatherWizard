import SwiftUI

extension Double {
  func lerp(min: Double, max: Double) -> Double {
    return min + (self * (max - min))
  }
}

struct HumidityView: View {
  let humidity: Int

  // Animation properties
  @State private var currentHumidity: Double = 0

  var body: some View {
    ZStack {
      Circle()
        .trim(from: 0, to: CGFloat((Double(currentHumidity) / 100).lerp(min: 0, max: 0.75)))
        .rotation(.degrees(135))
        .stroke(
          Color.blue,
          style: .init(
            lineWidth: 6,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 0,
            dash: [],
            dashPhase: 0
          )
        )
        .frame(width: 80, height: 80, alignment: .center)
//        .animation(.easeInOut(duration: 1.0))
      Text(verbatim: "\(humidity)%")
    }.onAppear {
      currentHumidity = Double(humidity)
    }
  }
}

struct RingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HumidityView(humidity: 100)
      HumidityView(humidity: 50)
    }
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
