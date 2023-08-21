import UIKit
import Kingfisher
import SnapKit

class ArticleListCollectionViewCell: UICollectionViewCell {
    static let reuseId = "ArticleListCell"
    
    let placeholderImage = UIImage(named: "avatar")
    let avatarImageView = UIImageView()
    let authorNameLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.darkGray)
    let titleLabel = BambooLabel(fontSize: 13, weight: .medium, color: BambooColors.white)
    let likeIcon = UIImageView(image: UIImage(systemName: "suit.heart"))
    let commentIcon = UIImageView(image: UIImage(systemName: "message"))
    let likeLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.darkGray)
    let commentLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.darkGray)
    let createdAtLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.darkGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = BambooColors.navy
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(articleList: ArticleList) {
        if let profileImage = articleList.author.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            avatarImageView.kf.setImage(with: profileImageUrl, placeholder: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
        
        authorNameLabel.text = articleList.author.profile.username
        titleLabel.text = articleList.title
        likeLabel.text = "\(articleList.likeCount)"
        commentLabel.text = "\(articleList.commentCount)"
        createdAtLabel.text = DateHelper.getElapsedTime(articleList.createdAt)
    }
    
    private func configureUI() {
        let padding: CGFloat = 15
        [avatarImageView, authorNameLabel, titleLabel, likeIcon, likeLabel, commentIcon, commentLabel, createdAtLabel]
            .forEach { addSubview($0) }
        
        layer.cornerRadius = 12
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        likeIcon.tintColor = BambooColors.darkGray
        commentIcon.tintColor = BambooColors.darkGray
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(padding)
            make.width.height.equalTo(36)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(padding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorNameLabel.snp.bottom).inset(5)
            make.leading.equalTo(authorNameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(32)
        }
        
        likeIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.trailing.equalTo(likeLabel.snp.leading).offset(-10)
            make.width.height.equalTo(14)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeIcon.snp.centerY)
            make.trailing.equalTo(commentIcon.snp.leading).offset(-5)
            make.width.equalTo(13)
        }
        
        commentIcon.snp.makeConstraints { make in
            make.centerY.equalTo(likeLabel.snp.centerY)
            make.trailing.equalTo(commentLabel.snp.leading).offset(-10)
            make.width.height.equalTo(12)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentIcon.snp.centerY)
            make.trailing.equalTo(createdAtLabel.snp.leading).offset(-5)
            make.width.equalTo(13)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(padding)
        }
    }
}
