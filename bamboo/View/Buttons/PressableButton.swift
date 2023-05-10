import UIKit

class PressableButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            updateOpacity()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(onButtonTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(onButtonTouchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(onButtonTouchUp), for: .touchUpOutside)
        self.addTarget(self, action: #selector(onButtonTouchUp), for: .touchDragExit)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func onButtonTouchDown() {
        self.alpha = 0.5
    }

    
    @objc func onButtonTouchUp() {
        self.alpha = 1.0
    }
    
    
    private func updateOpacity() {
        if isEnabled {
            self.layer.opacity = 1
        } else {
            self.layer.opacity = 0.5
        }
    }
}
