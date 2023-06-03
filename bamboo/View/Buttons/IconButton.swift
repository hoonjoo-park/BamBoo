import UIKit
import SnapKit

class IconButton: PressableButton {
    let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setIcon(image: UIImage) {
        iconView.image = image
    }
    
    private func configureUI() {
        addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}
