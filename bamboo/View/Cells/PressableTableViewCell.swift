import UIKit

class PressableTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateSelectionState(isSelected: true)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        updateSelectionState(isSelected: false)
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        updateSelectionState(isSelected: false)
    }
    
    
    private func updateSelectionState(isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.5
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.2) {
                self.alpha = 1
            }
        }
    }
}
