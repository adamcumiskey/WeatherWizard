import Formatter
import SwiftUI

struct PressureView: View {
  let pressure: Double

  static let min = 870.0
  static let max = 1084.0

  @State var currentPressure: Double = PressureView.min

  func guageHeight(for frameHeight: CGFloat) -> CGFloat {
    let fraction = 1.0 - ((PressureView.max - currentPressure) / (PressureView.max - PressureView.min))
    return frameHeight * CGFloat(fraction)
  }

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        Rectangle()
          .foregroundColor(.clear)
        VStack {
          Spacer()
          Rectangle()
            .cornerRadius(5.0)
            .foregroundColor(.blue)
            .frame(height: guageHeight(for: geometry.size.height))
            .overlay(
              Text(verbatim: .pressureString(currentPressure))
                .font(.caption)
                .foregroundColor(.white)
            )
//            .animation(.easeInOut(duration: 1.0))
        }
      }
    }.frame(width: 80, height: 80, alignment: .center)
    .onAppear {
      currentPressure = pressure
    }
  }
}

struct PressureView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PressureView(pressure: 900)
    }.previewLayout(.sizeThatFits)
    .padding()
  }
}
