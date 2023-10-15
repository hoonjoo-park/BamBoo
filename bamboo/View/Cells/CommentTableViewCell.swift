import UIKit
import SnapKit
import Kingfisher
import RxSwift

protocol CommentCellDelegate: AnyObject {
    func openActionSheet(commentId: Int)
    func replyComment(commentId: Int)
    func navigateToUserPofile(author: User)
}

class CommentTableViewCell: UITableViewCell {
    static let reuseId = "CommentTableViewCell"
    
    let disposeBag = DisposeBag()
    var delegate: CommentCellDelegate!
    var currentComment: Comment!
    var articleVM: ArticleVM!
    
    let profileImageView = UIImageView()
    let usernameButton = LabelButton(fontSize: 12, weight: .medium, color: BambooColors.gray)
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
    
    
    func setCell(comment: Comment, userVM: UserViewModel, articleVM: ArticleVM) {
        if let profileImage = comment.author.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
        
        self.articleVM = articleVM
        bindArticleVM()
        usernameButton.buttonLabel.text = comment.author.profile.username
        createdAtLabel.text = DateHelper.getElapsedTime(comment.createdAt)
        commentLabel.text = comment.content
        currentComment = comment
        
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
        
        [profileImageView, usernameButton, createdAtLabel,
         replyButton, optionButton, commentLabel].forEach { contentView.addSubview($0) }
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().inset(verticalPadding)
            make.leading.equalToSuperview().inset(horizontalPadding)
        }
        
        usernameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameButton)
            make.leading.equalTo(usernameButton.snp.trailing).offset(10)
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
    
    
    private func bindArticleVM() {
        guard let articleVM = articleVM else { return }
        
        articleVM.selectedCommentId.subscribe(onNext: { [weak self] selectedId in
            guard let self = self,
                  let currentComment = self.currentComment else { return }
            
            if selectedId == currentComment.id {
                self.layer.borderWidth = 1
                self.layer.borderColor = BambooColors.green.cgColor
                self.layer.cornerRadius = 2
            } else {
                self.layer.borderWidth = 0
                self.layer.cornerRadius = 0
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    private func configureButtonTargets() {
        optionButton.addTarget(self, action: #selector(handleTapOptionButton), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(handleTapReplyButton), for: .touchUpInside)
        usernameButton.addTarget(self, action: #selector(handleTapUsernameButton), for: .touchUpInside)
    }
    
    
    @objc func handleTapOptionButton() {
        if currentComment != nil {
            self.delegate.openActionSheet(commentId: currentComment.id)
        }
    }
    
    
    @objc func handleTapReplyButton() {
        guard let currentComment = currentComment  else { return }
        
        self.delegate.replyComment(commentId: currentComment.id)
    }
    
    
    @objc func handleTapUsernameButton() {
        guard let currentComment = currentComment else { return }
        
        self.delegate.navigateToUserPofile(author: currentComment.author)
    }
}
