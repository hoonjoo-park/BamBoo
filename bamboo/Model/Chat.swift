import Foundation

struct ChatRoom: Codable {
    let id: Int
    let users: [ChatRoomUser]
    let createdAt: String
    let latestMessageId: Int?
    let latestMessage: Message?
}

struct ChatRoomUser: Codable {
    let profile: ChatRoomUserProfile
    let hasSeenLatestMessage: Bool
}

struct ChatRoomUserProfile: Codable {
    let id: Int
    let profileImage: String?
    let userId: Int
    let username: String
}

struct Message: Codable {
    let id: Int
    let senderId: Int
    let sender: User
    let chatRoomId: Int
    let content: String
    let createdAt: Date
}
