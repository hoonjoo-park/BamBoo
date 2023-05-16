import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let districts: [District]
}

struct District: Codable {
    let id: Int
    let cityId: Int
    let name: String
}

struct CityWithoutDistricts: Codable {
    let id: Int
    let name: String
}
