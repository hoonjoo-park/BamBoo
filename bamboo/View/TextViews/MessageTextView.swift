import UIKit

class MessageTextView: UITextView, UITextViewDelegate {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    
    private func configureUI() {
        backgroundColor = BambooColors.black
        textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        font = UIFont.systemFont(ofSize: 14)
    }

}
