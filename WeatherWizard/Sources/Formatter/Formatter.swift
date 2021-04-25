import Foundation

public extension String {
  static func temperatureString(_ value: Double, unit: UnitTemperature = .kelvin) -> String {
    let unit = Measurement<UnitTemperature>(value: value, unit: unit)
    return MeasurementFormatter.withoutDecimalNumbers.string(from: unit)
  }

  static func pressureString(_ value: Double, unit: UnitPressure = .hectopascals) -> String {
    let measurement = Measurement(value: value, unit: unit)
    return MeasurementFormatter().string(from: measurement)
  }

  static func speedString(_ value: Double, unit: UnitSpeed = .metersPerSecond) -> String {
    let measurement = Measurement(value: value, unit: unit)
    return MeasurementFormatter.withoutDecimalNumbers.string(from: measurement)
  }

  static func hourString(_ date: Date, timeZone: TimeZone) -> String {
    return DateFormatter.hourFormatter(timeZone: timeZone).string(from: date)
  }

  static func shortDateString(_ date: Date, timeZone: TimeZone) -> String {
    return DateFormatter.shortDateFormatter(timeZone: timeZone).string(from: date)
  }
}

private extension NumberFormatter {
  static var withoutDecimalNumbers: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.generatesDecimalNumbers = false
    return numberFormatter
  }
}

private extension MeasurementFormatter {
  static var withoutDecimalNumbers: MeasurementFormatter {
    let formatter = MeasurementFormatter()
    formatter.numberFormatter = .withoutDecimalNumbers
    return formatter
  }
}

private extension DateFormatter {
  static func hourFormatter(timeZone: TimeZone) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = timeZone
    formatter.setLocalizedDateFormatFromTemplate("HH:mm a")
    return formatter
  }

  static func shortDateFormatter(timeZone: TimeZone) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = timeZone
    formatter.timeStyle = .none
    formatter.setLocalizedDateFormatFromTemplate("EEE MMM d")
    return formatter
  }
}
