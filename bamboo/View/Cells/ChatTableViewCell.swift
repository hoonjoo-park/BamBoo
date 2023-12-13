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
    
    
    func setCell(message: Message, nextMessage: Message?) {
        guard let me = self.me else { return }

        contentLabel.text = message.content
        createdAtLabel.text = DateHelper.getTime(message.createdAt)
        
        if me.id == message.senderProfile.userId {
            configureMyMessageUI()
        } else {
            configureOpponentMessageUI()
        }
        
        guard let nextMessage = nextMessage else { return }
        
        configureUIByNextMessage(message, nextMessage)
    }
    
    
    private func configureUIByNextMessage(_ message:Message, _ nextMessage: Message) {
        let isNextMessageSentAtSameTime = DateHelper.getTime(nextMessage.createdAt) == DateHelper.getTime(message.createdAt)
        let isLastMessageOfSection = message.senderProfile.userId != nextMessage.senderProfile.userId
        
        if !isLastMessageOfSection && isNextMessageSentAtSameTime {
            createdAtLabel.isHidden = true
        }
        
        if isLastMessageOfSection {
            let marginGuide = contentView.layoutMarginsGuide
            
            bubble.snp.updateConstraints { make in
                make.bottom.equalTo(marginGuide.snp.bottom).inset(10)
            }
        }
    }
    
    
    private func configureDefaultUI() {
        backgroundColor = BambooColors.black
        
        [bubble, createdAtLabel].forEach { contentView.addSubview($0) }
        bubble.addSubview(contentLabel)
        bubble.layer.cornerRadius = 12
        contentLabel.numberOfLines = 0
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    
    private func configureMyMessageUI() {
        let marginGuide = contentView.layoutMarginsGuide
        bubble.backgroundColor = BambooColors.green
        

        bubble.snp.remakeConstraints { make in
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.65)
            make.trailing.equalTo(marginGuide.snp.trailing)
            make.verticalEdges.equalTo(marginGuide.snp.verticalEdges).inset(-5)
        }
        
        createdAtLabel.snp.remakeConstraints { make in
            make.trailing.equalTo(bubble.snp.leading).offset(-5)
            make.bottom.equalTo(bubble.snp.bottom)
        }
    }
    
    
    private func configureOpponentMessageUI() {
        let marginGuide = contentView.layoutMarginsGuide
        bubble.backgroundColor = BambooColors.darkGray
        
        bubble.snp.remakeConstraints { make in
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.65)
            make.leading.equalTo(marginGuide.snp.leading)
            make.verticalEdges.equalTo(marginGuide.snp.verticalEdges).inset(-5)
        }
        
        createdAtLabel.snp.remakeConstraints { make in
            make.leading.equalTo(bubble.snp.trailing).offset(5)
            make.bottom.equalTo(bubble.snp.bottom)
        }
    }
    
}
