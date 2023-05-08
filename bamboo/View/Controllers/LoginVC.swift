import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginVC: BottomSheetVC {
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
        view.backgroundColor = .clear
        
        [backdropView, containerView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, kakaoAuthButton, googleAuthButton, appleAuthButton].forEach {
            containerView.addSubview($0)
        }
        
        setAuthButtonConstraints(kakaoAuthButton, titleLabel, 30)
        setAuthButtonConstraints(googleAuthButton, kakaoAuthButton, 17)
        setAuthButtonConstraints(appleAuthButton, googleAuthButton, 17)
        
        backdropView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().offset(defaultHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
}


extension LoginVC: AuthButtonDelegate {
    func authCompletion(accessToken: String) {
        dismissBottomSheet()
        UserDefaults.standard.setToken(token: accessToken)
        
        let rootTabBarController = RootTabBarController()
        
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
