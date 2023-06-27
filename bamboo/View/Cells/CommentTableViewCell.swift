import UIKit
import SnapKit
import Kingfisher

protocol CommentCellDelegate: AnyObject {
    func openActionSheet(commentId: Int)
    func replyComment(commentId: Int)
}

class CommentTableViewCell: UITableViewCell {
    static let reuseId = "CommentTableViewCell"
    
    var delegate: CommentCellDelegate!
    var currentCommentId: Int!
    
    let profileImageView = UIImageView()
    let usernameLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.gray)
    let replyButton = IconButton()
    let optionButton = IconButton()
    let commentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        configureUI()
        configureButtonTargets()
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
    
    
    func setCell(comment: Comment, userVM: UserViewModel) {
        if let profileImage = comment.author.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            profileImageView.kf.setImage(with: profileImageUrl)
        }
        
        usernameLabel.text = comment.author.profile.username
        createdAtLabel.text = DateHelper.getElapsedTime(comment.createdAt)
        commentLabel.text = comment.content
        currentCommentId = comment.id
        
        guard let currentUser = userVM.getUser() else { return }
        
        let isMyComment = comment.author.id == currentUser.id
        
        replyButton.isHidden = isMyComment
        optionButton.isHidden = !isMyComment
    }
    
    
    private func configureUI() {
        let verticalPadding: CGFloat = 15
        let horizontalPadding: CGFloat = 20
        
        backgroundColor = BambooColors.black
        
        replyButton.iconView.image = UIImage(systemName: "arrowshape.turn.up.right")
        replyButton.iconView.tintColor = BambooColors.gray
        optionButton.iconView.image = UIImage(systemName: "ellipsis")
        optionButton.iconView.tintColor = BambooColors.gray
        
        [profileImageView, usernameLabel, createdAtLabel,
         replyButton, optionButton, commentLabel].forEach { contentView.addSubview($0) }
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().inset(verticalPadding)
            make.leading.equalToSuperview().inset(horizontalPadding)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameLabel)
            make.leading.equalTo(usernameLabel.snp.trailing).offset(10)
        }
        
        replyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().offset(verticalPadding)
            make.width.height.equalTo(15)
        }
        
        optionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().offset(verticalPadding)
            make.width.equalTo(15)
            make.height.equalTo(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }
    }
    
    
    private func configureButtonTargets() {
        optionButton.addTarget(self, action: #selector(handleTapOptionButton), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(handleTapReplyButton), for: .touchUpInside)
    }
    
    
    @objc func handleTapOptionButton() {
        if currentCommentId != nil {
            self.delegate.openActionSheet(commentId: currentCommentId)
        }
    }
    
    
    @objc func handleTapReplyButton() {
        if currentCommentId != nil {
            self.delegate.replyComment(commentId: currentCommentId)
        }
    }
}
