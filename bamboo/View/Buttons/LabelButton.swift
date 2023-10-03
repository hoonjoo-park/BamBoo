import UIKit
import SnapKit

class LabelButton: PressableButton {
    var buttonLabel = BambooLabel(fontSize: 14, weight: .bold, color: BambooColors.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI(true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor, isCenter: Bool? = nil) {
        super.init(frame: .zero)
        buttonLabel = BambooLabel(fontSize: fontSize, weight: weight, color: color)
        configureUI(isCenter ?? true)
    }
    
    
    private func configureUI(_ isCenter: Bool) {
        addSubview(buttonLabel)
        
        if isCenter {
            buttonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        } else {
            buttonLabel.snp.makeConstraints {
                $0.leading.equalToSuperview()
            }
        }
    }
}
