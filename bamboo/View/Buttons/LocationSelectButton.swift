import UIKit
import SnapKit

class LocationSelectButton: PressableButton {
    var isTapped: Bool = false {
        didSet {
            updateBorder()
        }
    }
    
    let placeholder = BambooLabel(fontSize: 12, weight: .semibold, color: BambooColors.white)
    let arrowIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    init(text: String) {
        super.init(frame: .zero)
        placeholder.text = text
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        backgroundColor = BambooColors.lightNavy
        layer.cornerRadius = 8
        
        [placeholder, arrowIcon].forEach {
            addSubview($0)
        }
        
        placeholder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        arrowIcon.tintColor = BambooColors.white
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(15)
        }
    }
    
    private func updateBorder() {
        if isTapped {
            layer.borderWidth = 1
            layer.borderColor = BambooColors.green.cgColor
        } else {
            layer.borderWidth = 0
        }
    }
}
