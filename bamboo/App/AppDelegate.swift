import UIKit
import FirebaseCore
import GoogleSignIn
import RxKakaoSDKCommon


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // MARK: Kakao Auth Settings
        let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String
        if let kakaoAppKeyValue = kakaoAppKey {
            RxKakaoSDK.initSDK(appKey: kakaoAppKeyValue)
        }
        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

