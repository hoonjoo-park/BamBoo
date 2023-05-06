import Foundation

struct Article: Codable {
    let id: Int
    let title: String
    let content: String
    let authorId: Int
    let author: User
    let comments: [Comment]
    let likes: [ArticleLike]
    let cityId: Int
    let districtId: Int?
    let createdAt: String
}

struct ArticleLike: Codable {
    let userId: Int
    let articleId: Int
    let article: Article
}

struct Comment: Codable {
    let id: Int
    let content: String
    let author: User
    let articleId: Int
    let article: Article
    let parentCommentId: Int?
    let createdAt: String
}
