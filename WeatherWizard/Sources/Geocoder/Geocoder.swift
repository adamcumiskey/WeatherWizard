import Combine
import CoreLocation

public enum GeocoderError: Error {
  case coreLocation(Error)
  case noResults
  case failing
}

public struct Geocoder {
  public let getCoordinate: (String) -> AnyPublisher<CLLocationCoordinate2D, Error>
}

public extension Geocoder {
  static var live: Geocoder {
    let g = CLGeocoder()
    return .init(
      getCoordinate: { query in
        return Deferred {
          Future<CLLocationCoordinate2D, Error> { promise in
            g.geocodeAddressString(query) { placemarks, error in
              if let error = error {
                promise(.failure(GeocoderError.coreLocation(error)))
              } else if let placemarks = placemarks,
                        let location = placemarks.first?.location {
                promise(.success(location.coordinate))
              } else {
                promise(.failure(GeocoderError.noResults))
              }
            }
          }
        }.eraseToAnyPublisher()
      }
    )
  }

  static var mock: Geocoder {
    return .init(getCoordinate: { _ in
      return Just(.mock)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    })
  }

  static var failing: Geocoder {
    return .init(getCoordinate: { _ in
      return Fail(error: GeocoderError.failing).eraseToAnyPublisher()
    })
  }
}

extension CLLocationCoordinate2D {
  public static var mock: CLLocationCoordinate2D {
    .init()
  }
}
