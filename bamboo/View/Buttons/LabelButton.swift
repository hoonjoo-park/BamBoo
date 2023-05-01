import UIKit
import SnapKit

class LabelButton: UIButton {
    var buttonLabel = BambooLabel(fontSize: 14, weight: .bold, color: BambooColors.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor) {
        super.init(frame: .zero)
        buttonLabel = BambooLabel(fontSize: fontSize, weight: weight, color: color)
        configureUI()
    }
    
    
    private func configureUI() {
        addSubview(buttonLabel)
        
        buttonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
