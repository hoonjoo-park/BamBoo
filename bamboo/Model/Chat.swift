import Foundation

struct ChatRoom: Codable {
    let id: Int
    let senderProfile: SenderProfile
    let updatedAt: String
    let lastMessage: Message?
}

struct SenderProfile: Codable {
    let id: Int
    let profileImage: String?
    let userId: Int
    let username: String
}

struct MessageResponse: Codable {
    let page: Int
    let messages: [Message]
}

struct Message: Codable {
    let id: Int
    let senderProfile: SenderProfile
    let chatRoomId: Int
    let content: String
    let createdAt: String
}
