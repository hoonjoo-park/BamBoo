import UIKit

protocol GoogleAuthButtonDelegate: AnyObject {
    func runGoogleAuth()
}

class GoogleAuthButton: AuthButton {
    override init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, iconName: String) {
        super.init(fontSize: fontSize, weight: weight, color: color, iconName: iconName)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        buttonLabel.text = "구글 로그인"
        backgroundColor = BambooColors.white
        
        self.addTarget(self, action: #selector(handleTapGoogleAuthButton), for: .touchUpInside)
    }
    
    
    @objc func handleTapGoogleAuthButton() {
        delegate.runGoogleAuth()
    }
}
