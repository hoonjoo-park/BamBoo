import UIKit
import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser

class KakaoAuthButton: AuthButton {
    let disposeBag = DisposeBag()
    
    override init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, iconName: String) {
        super.init(fontSize: fontSize, weight: weight, color: color, iconName: iconName)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        buttonLabel.text = "카카오 로그인"
        backgroundColor = BambooColors.kakaoYello
        
        self.addTarget(self, action: #selector(runKakaoAuth), for: .touchUpInside)
    }
    
    
    @objc func runKakaoAuth() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ [unowned self] oauthToken in
                    _ = oauthToken
                    let accessToken = oauthToken.accessToken
                    self.handleAuth(accessToken)
                }, onError: {error in
                    print("runKakaoAuth error:\(error)")
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext:{ [unowned self] oauthToken in
                    _ = oauthToken
                    let accessToken = oauthToken.accessToken
                    self.handleAuth(accessToken)
                }, onError: {error in
                    print("runKakaoAuth error:\(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    
    private func handleAuth(_ accessToken: String){
        postOAuth(accessToken, provider: "kakao") { token in
            if let token = token {
                self.delegate?.authCompletion(accessToken: token)
            } else {
                print("[postOAuth] Failed to receive token")
            }
        }
    }
}
