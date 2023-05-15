import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginVC: BottomSheetVC {
    let disposeBag = DisposeBag()
    let userVM = UserViewModel()
    let kakaoAuthButton = KakaoAuthButton(fontSize: 14, weight: .medium, color: BambooColors.black, iconName: "kakaoIcon")
    let googleAuthButton = GoogleAuthButton(fontSize: 14, weight: .medium, color: BambooColors.black, iconName: "googleIcon")
    let appleAuthButton = AppleAuthButton(fontSize: 14, weight: .medium, color: BambooColors.white, iconName: "appleIcon")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleAuthButton.delegate = self
        kakaoAuthButton.delegate = self
        appleAuthButton.delegate = self
        configureUI()
    }
    
    
    private func setAuthButtonConstraints(_ button: AuthButton, _ topAnchorView: UIView, _ topAnchorValue: CGFloat) {
        button.snp.makeConstraints {
            $0.horizontalEdges.equalTo(containerView).inset(45)
            $0.top.equalTo(topAnchorView.snp.bottom).offset(topAnchorValue)
            $0.height.equalTo(45)
        }
    }
    
    
    private func configureUI() {
        [kakaoAuthButton, googleAuthButton, appleAuthButton].forEach {
            containerView.addSubview($0)
        }
        
        setAuthButtonConstraints(kakaoAuthButton, titleLabel, 30)
        setAuthButtonConstraints(googleAuthButton, kakaoAuthButton, 17)
        setAuthButtonConstraints(appleAuthButton, googleAuthButton, 17)
    }
}


extension LoginVC: AuthButtonDelegate {
    func authCompletion(accessToken: String) {
        dismissBottomSheet()
        UserDefaults.standard.setToken(token: accessToken)
        
        NetworkManager.shared.fetchUser()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.userVM.updateUser(user)
            }, onError: { error in
                print("[Fetch User Error], \(error)")
                UserDefaults.standard.removeToken()
                
            }).disposed(by: disposeBag)
        
        let rootTabBarController = RootTabBarController(userVM: userVM)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = rootTabBarController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func runGoogleAuth() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, err in
            
            if let error = err {
                print("[Google Auth]", error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        }
    }
}
