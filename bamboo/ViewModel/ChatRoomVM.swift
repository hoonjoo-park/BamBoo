import Foundation
import RxSwift
import RxCocoa

class ChatRoomViewModel {
    static let shared = ChatRoomViewModel()
    
    private let chatRoomsSubject = BehaviorSubject<[ChatRoom?]>(value: [])
    var chatRooms: Observable<[ChatRoom?]> {
        return chatRoomsSubject.asObservable()
    }
    
    
    func setChatRooms(chatRooms data: [ChatRoom]) {
        chatRoomsSubject.onNext(data)
    }
    
    
    func getChatRooms() -> [ChatRoom?] {
        do {
            return try chatRoomsSubject.value()
        } catch {
            print("getChatRooms error: \(error)")
            return []
        }
    }
    
    
    func addChatRoom(chatRoom: ChatRoom) {
        do {
            let currentChatRooms = try chatRoomsSubject.value()
            
            if currentChatRooms.isEmpty {
                chatRoomsSubject.onNext([chatRoom])
            } else {
                chatRoomsSubject.onNext(currentChatRooms + [chatRoom])
            }
        } catch {
            print("updateChatRooms error: \(error)")
        }
    }
}
