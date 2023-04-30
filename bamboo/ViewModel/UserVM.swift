import Foundation
import RxSwift
import RxCocoa

class UserViewModel {
    private let userSubject = BehaviorSubject<User?>(value: nil)
    var user: Observable<User?> {
        return userSubject.asObservable()
    }
    
    func updateUser(_ user: User) {
        userSubject.onNext(user)
    }
}
