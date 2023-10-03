import Foundation

struct ChatRoom: Codable {
    let id: Int
    let users: [User]
    let messages: [Message]
    let unReadCount: Int
    let createdAt: Date
    let updatedAt: Date
}

struct Message: Codable {
    let id: Int
    let senderId: Int
    let sender: User
    let chatRoomId: Int
    let chatRoom: ChatRoom
    let content: String
    let createdAt: Date
}
