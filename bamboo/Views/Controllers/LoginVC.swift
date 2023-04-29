import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginVC: UIViewController {
    let maxBackdropAlpha = 0.6
    let defaultHeight: CGFloat = 315
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = BambooColors.navy
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = BambooColors.black
        view.alpha = maxBackdropAlpha
        return view
    }()
    
    lazy var titleLabel: BambooLabel = {
        let label = BambooLabel(fontSize: 20, weight: .semibold, color: BambooColors.white)
        label.text = "로그인"
        return label
    }()
    
    let kakaoAuthButton = KakaoAuthButton(fontSize: 14, weight: .medium, color: BambooColors.black, iconName: "kakaoIcon")
    let googleAuthButton = GoogleAuthButton(fontSize: 14, weight: .medium, color: BambooColors.black, iconName: "googleIcon")
    let appleAuthButton = AppleAuthButton(fontSize: 14, weight: .medium, color: BambooColors.white, iconName: "appleIcon")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleAuthButton.delegate = self
        kakaoAuthButton.delegate = self
        appleAuthButton.delegate = self
        configureUI()
        configureGestureHandler()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
        animatePresentBackdropView()
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
            $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    private func configureGestureHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapBackdrop))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func animatePresentBackdropView() {
        backdropView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backdropView.alpha = self.maxBackdropAlpha
        }
    }
    
    
    private func dismissBottomSheet() {
        dismissContainerView()
        dismissBackdropView()
    }
    
    
    private func dismissContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func dismissBackdropView() {
        backdropView.alpha = maxBackdropAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.backdropView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    
    @objc func handleTapBackdrop() {
        dismissBottomSheet()
    }
}


extension LoginVC: AuthButtonDelegate {
    func authCompletion(accessToken: String) {
        dismissBottomSheet()
        UserDefaults.standard.setToken(token: accessToken)
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
