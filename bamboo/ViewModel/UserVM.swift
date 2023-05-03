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
    
    
    func updateProfile(_ profile: UserProfile) {
        guard let currentUser = try? userSubject.value() else { return }
        
        let updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            name: currentUser.name,
            createdAt: currentUser.createdAt,
            profile: UserProfile(
                username: profile.username,
                profileImage: profile.profileImage
            )
        )
        
        userSubject.onNext(updatedUser)
    }
}
