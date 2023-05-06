import Foundation

struct ChatRoomUser: Codable {
    let userId: Int
    let user: User
    let chatRoomId: Int
    let chatRoom: ChatRoom
}

struct ChatRoom: Codable {
    let id: Int
    let users: [ChatRoomUser]
    let messages: [Message]
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
