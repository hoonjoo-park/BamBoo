import UIKit
import SnapKit

class ArticleListEmptyView: UIView {
    let notFoundLabel = BambooLabel(fontSize: 18, weight: .bold, color: BambooColors.darkGray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        addSubview(notFoundLabel)
        
        notFoundLabel.text = "게시글이 없습니다 ;("
        
        notFoundLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(120)
        }
    }
    
}
