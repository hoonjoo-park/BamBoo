import UIKit
import SnapKit

class CommentContainerView: UIView {
    let borderContainer = UIView()
    let textView = CommentTextView()
    let submitButton = LabelButton(fontSize: 14, weight: .regular, color: BambooColors.green)
    
    let lineHeight: CGFloat = 16
    let maxNumberOfLines = 7

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        backgroundColor = BambooColors.navy
        
        addSubview(borderContainer)
        [textView, submitButton].forEach { borderContainer.addSubview($0) }
        textView.delegate = self
        
        borderContainer.layer.borderWidth = 1
        borderContainer.layer.borderColor = BambooColors.gray.cgColor
        borderContainer.layer.cornerRadius = 22.5
        borderContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(47)
        }
        
        submitButton.buttonLabel.text = "등록"
        submitButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(20)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(submitButton.snp.leading).offset(-15)
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension CommentContainerView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let maxSize = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(maxSize)
        
        if estimatedSize.height > lineHeight * CGFloat(maxNumberOfLines) {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            borderContainer.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height)
            }
            
            self.snp.updateConstraints { make in
                make.height.equalTo(38 + estimatedSize.height)
            }
        }
    }
}
