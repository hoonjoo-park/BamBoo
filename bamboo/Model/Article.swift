import Foundation

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
    var likes: [ArticleLike]
    let cityName: String
    let districtName: String?
    let commentCount: Int
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
    let nestedComments: [Comment]
    let createdAt: String
}

struct ArticleList: Codable {
    let id: Int
    let title: String
    let content: String
    let author: User
    let cityId: Int
    let districtId: Int?
    let commentCount: Int
    let likeCount: Int
    let createdAt: String
}
