import Foundation
import UIKit

extension UserDefaults {
    
    func setToken(token: String) {
        self.set(token, forKey: "user-token")
    }
    
    
    func getToken() -> String? {
        return self.string(forKey: "user-token")
    }
    
    
    func removeToken() {
        self.removeObject(forKey: "user-token")
        
        let onboardingVC = OnboardingVC()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = onboardingVC
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
