import Foundation
import SocketIO

enum SocketEvent {
    static let message = "message"
    static let connect = "connect"
    static let disconnect = "disconnect"
    static let chatRooms = "chatRooms"
    static let updateChatRoom = "updateChatRoom"
    static let createChatRoom = "createChatRoom"
    static let enterRoom = "enterRoom"
}

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    private let decoder = JSONDecoder()
    let chatRoomVM = ChatRoomViewModel.shared
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    
    override init() {
        super.init()
    }
    
    
    func configureSocket(token: String) {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3090")!,
                                config: [
                                    .log(true),
                                    .compress,
                                    .connectParams(["token": token])
                                ])
        
        socket = manager.defaultSocket
    }
    
    
    func connectSocket() {
        guard let socket = socket else { return }
        
        socket.connect()
        
        setSocketEmitListener()
    }
    
    
    func disconnectSocket() {
        guard let socket = socket else { return }
        
        socket.disconnect()
    }
    
    
    func sendMessage(message: String, userId: Int) {
        self.socket.emit(SocketEvent.message, ["message": message, "userId": userId])
    }
    
    
    func createChatRoom(userId: Int) {
        self.socket.emit(SocketEvent.createChatRoom, ["userId": userId])
    }
    
    
    func enterRoom(chatRoomId: Int) {
        self.socket.emit(SocketEvent.enterRoom, ["chatRoomId": chatRoomId])
    }
    
    
    func setSocketEmitListener() {
        // chatRooms
        self.socket.on(SocketEvent.chatRooms) { data, ack  in
            guard let chatRoomsData = data.first else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: chatRoomsData)
                let chatRooms = try self.decoder.decode([ChatRoom].self, from: jsonData)
                
                self.chatRoomVM.setChatRooms(chatRooms: chatRooms)
            } catch {
                print("chatRooms error: \(error)")
            }
        }
        
        // updateChatRoom
        self.socket.on(SocketEvent.updateChatRoom) { data, ack in
            guard let chatRoomData = data.first else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: chatRoomData)
                let chatRoom = try self.decoder.decode(ChatRoom.self, from: jsonData)
                
                self.chatRoomVM.updateChatRoom(chatRoom: chatRoom)
            } catch {
                print("updateChatRoom error: \(error)")
            }
        }
    }
}
