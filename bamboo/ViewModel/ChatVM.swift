import Foundation
import RxSwift
import RxCocoa

class ChatViewModel {
    static let shared = ChatViewModel()
    
    private let chatMessagesSubject = BehaviorSubject<[Message?]>(value: [])
    var chatMessages: Observable<[Message?]> {
        return chatMessagesSubject.asObservable()
    }
    private let pageSubject = BehaviorSubject<Int>(value: 1)
    var page: Observable<Int> {
        return pageSubject.asObservable()
    }
    
    
    func setInitialMessages(_ response: MessageResponse) {
        chatMessagesSubject.onNext(response.messages)
        pageSubject.onNext(response.page)
    }
    
    
    func addMessage(_ message: Message) {
        let currentMessages = getMessages()
        
        chatMessagesSubject.onNext([message] + currentMessages)
    }
    
    
    func addMoreMessages(_ response: MessageResponse) {
        let currentMessages = getMessages()
        
        chatMessagesSubject.onNext(response.messages + currentMessages)
        pageSubject.onNext(response.page)
    }
    
    
    func getMessages() -> [Message?] {
        do {
            return try chatMessagesSubject.value()
        } catch {
            print("getMessaged error: \(error)")
            return []
        }
    }
    
    
    func getPage() -> Int {
        do {
            return try pageSubject.value()
        } catch {
            print("getPage error: \(error)")
            return 1
        }
    }
    
    
    func clearChatMessages() {
        chatMessagesSubject.onNext([])
    }
}
