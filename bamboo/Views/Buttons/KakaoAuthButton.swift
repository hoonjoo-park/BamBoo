import UIKit

class KakaoAuthButton: AuthButton {
    override init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, iconName: String) {
        super.init(fontSize: fontSize, weight: weight, color: color, iconName: iconName)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        buttonLabel.text = "카카오 로그인"
        layer.cornerRadius = 22
        backgroundColor = BambooColors.kakaoYello
        
        self.addTarget(self, action: #selector(runKakaoAuth), for: .touchUpInside)
    }
    
    
    @objc func runKakaoAuth() {
        print("Kakao Auth!!")
    }
}
