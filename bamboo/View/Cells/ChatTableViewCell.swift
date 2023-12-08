import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    static let reuseId = "ChatTableViewCell"
    
    let me = UserViewModel.shared.getUser()
    
    let container = UIView()
    let bubble = UIView()
    let contentLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.white)
    let createdAtLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        configureDefaultUI()
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
    
    
    func setCell(message: Message) {
        guard let me = self.me else { return }

        contentLabel.text = message.content
        createdAtLabel.text = DateHelper.getTime(message.createdAt)
        
        
        if me.id == message.senderProfile.userId {
            configureMyMessageUI()
        } else {
            configureOpponentMessageUI()
        }
    }
    
    
    private func configureDefaultUI() {
        self.addSubview(container)
        
        [bubble, createdAtLabel].forEach { container.addSubview($0) }
        
        backgroundColor = BambooColors.black
        bubble.addSubview(contentLabel)
        bubble.layer.cornerRadius = 12
        
        container.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    
    private func configureMyMessageUI() {
        bubble.backgroundColor = BambooColors.green
        
        
        bubble.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
        }
        
        createdAtLabel.snp.remakeConstraints { make in
            make.trailing.equalTo(bubble.snp.leading).offset(-5)
            make.bottom.equalTo(bubble.snp.bottom)
        }
    }
    
    
    private func configureOpponentMessageUI() {
        bubble.backgroundColor = BambooColors.darkGray
        
        bubble.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
        }
        
        createdAtLabel.snp.remakeConstraints { make in
            make.leading.equalTo(bubble.snp.trailing).offset(5)
            make.bottom.equalTo(bubble.snp.bottom)
        }
    }
    
}
