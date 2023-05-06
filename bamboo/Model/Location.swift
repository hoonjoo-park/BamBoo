import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let districts: [District]
}

struct District: Codable {
    let id: Int
    let city: City
    let name: String
}
