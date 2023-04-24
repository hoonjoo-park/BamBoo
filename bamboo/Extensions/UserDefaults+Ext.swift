import Foundation

extension UserDefaults {
    
    func setToken(token: String) {
        self.set(token, forKey: "user-token")
    }
    
    
    func getToken() -> String? {
        return self.string(forKey: "user-token")
    }
    
    
    func removeToken() {
        self.removeObject(forKey: "user-token")
    }
}
