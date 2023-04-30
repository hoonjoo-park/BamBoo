import Foundation

struct User: Codable {
    let id: Int
    let email: String?
    let name: String
    let createdAt: String
    let profile: UserProfile
}

struct UserProfile: Codable {
    let username: String
    let profileImage: String?
}
