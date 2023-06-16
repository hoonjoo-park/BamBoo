import UIKit

class CommentTextView: UITextView, UITextViewDelegate {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureUI()
        self.delegate = self
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        self.delegate = self
    }
    
    
    private func configureUI() {
        backgroundColor = BambooColors.navy
        textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        font = UIFont.systemFont(ofSize: 14)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let maxSize = CGSize(width: self.frame.size.width, height: 255.0)
        let expectedSize = sizeThatFits(maxSize)
        
        isScrollEnabled = expectedSize.height > maxSize.height
        
        superview?.superview?.setNeedsLayout()
        superview?.superview?.layoutIfNeeded()
    }
}
