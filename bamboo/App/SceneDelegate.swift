import UIKit
import RxSwift
import RxCocoa
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    let userVM = UserViewModel.shared
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let token = UserDefaults.standard.getToken()
        
        if token == nil {
            setRootAsOnboarding()
        } else {
            NetworkManager.shared.fetchUser()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] user in
                    guard let self = self, let token = token else { return }
                    
                    self.userVM.login(user, token)
                    self.setRootAsTabBar()
                }, onError: { error in
                    print("[Fetch User Error], \(error)")
                    
                    UserDefaults.standard.removeToken()
                    
                    self.setRootAsOnboarding()
                }).disposed(by: disposeBag)
        }
    }
    
    
    private func setRootAsOnboarding() {
        let onboardingVC = OnboardingVC()
        let navVC = UINavigationController(rootViewController: onboardingVC)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
    
    
    private func setRootAsTabBar() {
        let rootTabBarController = RootTabBarController(userVM: self.userVM)
        self.window?.rootViewController = rootTabBarController
        self.window?.makeKeyAndVisible()
    }
    
    
    // MARK: Kakao Auth handleOpenUrl()
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        SocketIOManager.shared.connectSocket()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        SocketIOManager.shared.disconnectSocket()
    }
}
