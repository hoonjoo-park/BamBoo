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
                .subscribe(onNext:{ (oauthToken) in
                    _ = oauthToken
                    let accessToken = oauthToken.accessToken
                    
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext:{ (oauthToken) in
                    _ = oauthToken
                    let accessToken = oauthToken.accessToken
                    
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    
    private func handleAuth() {
        // TODO: 기존 회원인지 아닌지 체크 후 회원이면 로그인, 그렇지 않을 경우 회원가입 자동으로 시키는 백엔드 로직 구현 및 연동
    }
}
