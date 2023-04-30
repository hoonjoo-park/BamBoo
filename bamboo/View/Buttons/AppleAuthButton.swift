import UIKit

class AppleAuthButton: AuthButton {
    override init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, iconName: String) {
        super.init(fontSize: fontSize, weight: weight, color: color, iconName: iconName)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        buttonLabel.text = "애플 로그인"
        backgroundColor = BambooColors.pureBlack
        
        self.addTarget(self, action: #selector(runAppleAuth), for: .touchUpInside)
    }
    
    
    @objc func runAppleAuth() {
        print("Apple Auth Button Tapped!")
    }
}
