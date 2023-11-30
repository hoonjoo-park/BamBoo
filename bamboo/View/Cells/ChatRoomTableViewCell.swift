import UIKit
import SnapKit
import Kingfisher

class ChatRoomTableViewCell: UITableViewCell {
    static let reuseId = "ChatRoomListCollectionViewCell"
    
    let profileImageView = UIImageView()
    let placeholderImage = UIImage(named: "avatar")
    let usernameLabel = BambooLabel(fontSize: 14, weight: .semibold, color: BambooColors.white)
    let latestMessageLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.darkGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        [profileImageView, usernameLabel, latestMessageLabel, createdAtLabel].forEach { addSubview($0) }
    
        backgroundColor = BambooColors.black
        profileImageView.layer.cornerRadius = 12
        profileImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        latestMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.leading)
            make.bottom.equalTo(profileImageView.snp.bottom).inset(2)
            make.trailing.equalToSuperview().inset(15)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    
    func setCell(chatRoom: ChatRoom) {
        guard let me = UserViewModel.shared.getUser(),
              let opponentUser = chatRoom.users.filter({ user in return user.profile.userId != me.id }).first
        else { return }
        
        if let profileImage = opponentUser.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            profileImageView.setImageWithRetry(url: profileImageUrl, retry: 5)
        } else {
            profileImageView.image = placeholderImage
        }
        
        usernameLabel.text = opponentUser.profile.username
        latestMessageLabel.text = chatRoom.latestMessage?.content ?? "채팅방이 생성되었습니다."
        createdAtLabel.text = DateHelper.getElapsedTime(chatRoom.createdAt)
    }
}
