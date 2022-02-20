

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let metaWeatherLocationResponse = try? newJSONDecoder().decode(MetaWeatherLocationResponse.self, from: jsonData)

import Foundation

// MARK: - MetaWeatherLocationResponseElement
struct MetaWeatherLocationResponseElement: Codable {
    let distance: Int
    let title: String
    let locationType: LocationType
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case distance, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias MetaWeatherLocationResponse = [MetaWeatherLocationResponseElement]
