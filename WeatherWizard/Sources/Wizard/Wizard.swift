import Foundation

public enum Wizard: String, CaseIterable {
  case male0 = "🧙‍♂️"
  case male1 = "🧙🏻‍♂️"
  case male2 = "🧙🏼‍♂️"
  case male3 = "🧙🏽‍♂️"
  case male4 = "🧙🏾‍♂️"
  case male5 = "🧙🏿‍♂️"

  case female0 = "🧙‍♀️"
  case female1 = "🧙🏻‍♀️"
  case female2 = "🧙🏼‍♀️"
  case female3 = "🧙🏽‍♀️"
  case female4 = "🧙🏾‍♀️"
  case female5 = "🧙🏿‍♀️"

  public static var random: Wizard {
    guard let element = allCases.randomElement() else {
      fatalError("you must provide at least one wizard")
    }
    return element
  }
}
