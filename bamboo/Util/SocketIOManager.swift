import Foundation
import SocketIO

enum SocketEvent {
    static let message = "message"
    static let connect = "connect"
    static let disconnect = "disconnect"
}

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3090")!,
                                config: [.log(true), .compress])
    
    var socket: SocketIOClient!
    
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
    }
    
    
    func connectSocket() {
        guard let socket = socket else { return }
        
        socket.connect()
    }
    
    
    func disconnectSocket() {
        guard let socket = socket else { return }
        
        socket.disconnect()
    }
    
    
    func sendMessage(message: String, userId: Int) {
        self.socket.emit(SocketEvent.message, ["message": message, "userId": userId])
    }
    
}
