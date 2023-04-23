import UIKit

class BambooLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    convenience init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor) {
        self.init(frame: .zero)
        
        lineBreakMode = .byTruncatingTail
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
        configureLabel()
    }
    
    
    func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
    }

}
