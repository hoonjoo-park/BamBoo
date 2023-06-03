import UIKit

class NestedCommentTableViewCell: UITableViewCell {
    static let reuseId = "NestedCommentTableViewCell"
    
    let commentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCell(comment: Comment) {
        commentLabel.text = comment.content
    }
    
    
    private func configureUI() {
        backgroundColor = BambooColors.navy
        
        [commentLabel].forEach { addSubview($0) }
        
        commentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(20)
        }
    }

}
