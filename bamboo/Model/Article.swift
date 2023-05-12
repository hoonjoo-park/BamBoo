import Foundation

struct CityWithoutDistricts: Codable {
    let id: Int
    let name: String
}

struct Article: Codable {
    let id: Int
    let title: String
    let content: String
    let authorId: Int
    let cityId: Int
    let districtId: Int?
    let createdAt: String
    let author: User
    let comments: [Comment]
    let likes: [ArticleLike]
    let city: CityWithoutDistricts
    let district: District?
}

struct ArticleLike: Codable {
    let userId: Int
    let articleId: Int
}

struct Comment: Codable {
    let id: Int
    let content: String
    let author: User
    let articleId: Int
    let parentCommentId: Int?
    let createdAt: String
}
