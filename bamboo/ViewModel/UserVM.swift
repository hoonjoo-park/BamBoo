import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class UserViewModel {
    static let shared = UserViewModel()
    
    private let userSubject = BehaviorSubject<User?>(value: nil)
    var user: Observable<User?> {
        return userSubject.asObservable()
    }
    
    
    func updateUser(_ user: User) {
        userSubject.onNext(user)
    }
    
    
    func login(_ user: User, _ token: String) {
        updateUser(user)
        
        SocketIOManager.shared.configureSocket(token: token)
        SocketIOManager.shared.connectSocket()
    }
    
    
    func logout() {
        UserDefaults.standard.removeToken()
        SocketIOManager.shared.disconnectSocket()
        userSubject.onNext(nil)
    }
    
    
    func updateProfile(_ profile: UserProfile) {
        guard let currentUser = try? userSubject.value(),
              let profileImage = profile.profileImage else { return }
        
        let updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            name: currentUser.name,
            createdAt: currentUser.createdAt,
            profile: UserProfile(
                username: profile.username,
                profileImage: profileImage
            )
        )
        
        updateUser(updatedUser)
    }
    
    
    func getUser() -> User? {
        do {
            return try userSubject.value()
        } catch {
            print("getUser error: \(error)")
            return nil
        }
    }
}
