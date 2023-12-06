import Foundation
import RxSwift
import RxCocoa

class ChatViewModel {
    static let shared = ChatViewModel()
    
    private let chatMessagesSubject = BehaviorSubject<[Message?]>(value: [])
    var chatMessages: Observable<[Message?]> {
        return chatMessagesSubject.asObservable()
    }
    
    
    func setInitialMessages(messages: [Message]) {
        chatMessagesSubject.onNext(messages)
    }
    
    
    func addMessages(messages: [Message]) {
        let currentMessages = getMessages()
        
        chatMessagesSubject.onNext(currentMessages + messages)
    }
    
    
    func getMessages() -> [Message?] {
        do {
            return try chatMessagesSubject.value()
        } catch {
            print("getMessaged error: \(error)")
            return []
        }
    }
    
    
    func clearChatMessages() {
        chatMessagesSubject.onNext([])
    }
}
