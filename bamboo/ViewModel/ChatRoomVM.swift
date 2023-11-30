import Foundation
import RxSwift
import RxCocoa

class ChatRoomViewModel {
    static let shared = ChatRoomViewModel()
    
    private let chatRoomsSubject = BehaviorSubject<[ChatRoom?]>(value: [])
    var chatRooms: Observable<[ChatRoom?]> {
        return chatRoomsSubject.asObservable()
    }
    private(set) var createdChatRoomSubject = BehaviorRelay<ChatRoom?>(value: nil)
    
    
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
    
    
    func checkHasChatRoomWithOponent(userId: Int) -> ChatRoom? {
        do {
            let currentChatRooms = try chatRoomsSubject.value()
            
            guard !currentChatRooms.isEmpty else { return nil }
            
            return currentChatRooms.first { $0?.users[0].profile.userId == userId || $0?.users[1].profile.userId == userId } ?? nil
        } catch {
            print("checkHasChatRoomWithOponent error: \(error)")
            return nil
        }
    }
    
    
    func updateChatRoom(chatRoom: ChatRoom) {
        if (createdChatRoomSubject.value != nil) {
            createdChatRoomSubject.accept(nil)
        }
        
        do {
            var currentChatRooms = try chatRoomsSubject.value()
            
            if let index = currentChatRooms.firstIndex(where: { $0?.id == chatRoom.id }) {
                currentChatRooms[index] = chatRoom
            } else {
                currentChatRooms.append(chatRoom)
                createdChatRoomSubject.accept(chatRoom)
            }
            
            chatRoomsSubject.onNext(currentChatRooms)
        } catch {
            print("updateChatRoom error: \(error)")
        }
    }
}
