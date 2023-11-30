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
    
    
    func updateChatRoom(chatRoom: ChatRoom) {
        do {
            var currentChatRooms = try chatRoomsSubject.value()
            
            if let index = currentChatRooms.firstIndex(where: { $0?.id == chatRoom.id }) {
                currentChatRooms[index] = chatRoom
            } else {
                currentChatRooms.append(chatRoom)
            }
            
            chatRoomsSubject.onNext(currentChatRooms)
        } catch {
            print("updateChatRoom error: \(error)")
        }
    }
}
