import Foundation

struct ChatRoom: Codable {
    let id: Int
    let opponentProfile: OpponentProfile
    let updatedAt: String
    let lastMessage: Message?
}

struct OpponentProfile: Codable {
    let id: Int
    let profileImage: String?
    let userId: Int
    let username: String
}

struct Message: Codable {
    let id: Int
    let sender: User
    let chatRoomId: Int
    let content: String
    let createdAt: Date
}
