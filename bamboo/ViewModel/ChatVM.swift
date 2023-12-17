import Foundation
import RxSwift
import RxCocoa

class ChatViewModel {
    static let shared = ChatViewModel()
    
    private let chatMessagesSubject = BehaviorSubject<[Message?]>(value: [])
    var chatMessages: Observable<[Message?]> {
        return chatMessagesSubject.asObservable()
    }
    
    
    func setInitialMessages(_ messages: [Message]) {
        chatMessagesSubject.onNext(messages)
    }
    
    
    func addMessage(_ message: Message) {
        let currentMessages = getMessages()
        
        chatMessagesSubject.onNext([message] + currentMessages)
    }
    
    
    func addMoreMessages(_ messages: [Message]) {
        let currentMessages = getMessages()
        
        chatMessagesSubject.onNext(messages + currentMessages)
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
