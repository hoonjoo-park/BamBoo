import UIKit
import SnapKit

class ToastMessageView: UIView {
    let iconView = UIImageView()
    let messageLabel = BambooLabel(fontSize: 14, weight: .semibold, color: BambooColors.white)
    
    init(message: String, type: ToastMessageType) {
        super.init(frame: .zero)
        
        messageLabel.text = message
        
        switch type {
        case .success:
            iconView.image = UIImage(systemName: "checkmark.circle.fill")
            iconView.tintColor = BambooColors.green
            break
        case .failed:
            iconView.image = UIImage(systemName: "exclamationmark.circle.fill")
            iconView.tintColor = .systemRed
            break
        case .warn:
            iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            iconView.tintColor = BambooColors.kakaoYello
            break
        }
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 15
        
        [iconView, messageLabel].forEach { addSubview($0) }
        backgroundColor = BambooColors.gray
        layer.cornerRadius = 8
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(padding)
        }
        
        messageLabel.numberOfLines = 1
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }
    }
}
