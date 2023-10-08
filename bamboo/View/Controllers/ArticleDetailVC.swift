import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ArticleDetailVC: ToastMessageVC {
    let disposeBag = DisposeBag()
    var selectedArticleId: Int!
    var articleVM: ArticleVM!
    var userVM: UserViewModel!
    var comments: [Comment] = []
    
    let contentHeaderView = UIView()
    let profileImage = UIImageView()
    let authorNameButton = LabelButton(fontSize: 12, weight: .medium, color: BambooColors.gray, isCenter: false)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.gray)
    let titleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let contentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    let likeIcon = IconButton(frame: .zero)
    let likeCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let commentIcon = IconButton(frame: .zero)
    let commentCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let grayDivider = UIView()
    let commentTableView = UITableView(frame: .zero)
    let commentContainerView = CommentContainerView(frame: .zero)
    
    
    init(selectedId: Int, articleVM: ArticleVM, userVM: UserViewModel) {
        self.selectedArticleId = selectedId
        self.articleVM = articleVM
        self.userVM = userVM
        self.articleVM.fetchArticle(articleId: selectedId)
        
        super.init(nibName: nil, bundle: nil)
        
        bindArticleVM()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAddTargets()
        configureSubViews()
        configureCommentTableView()
        configureCommentContainerView()
        configureNotification()
        configureGestureHandler()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
        initLikeIcon()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        articleVM.updateSelectedCommentId(commentId: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            self.updateContentHeaderView()
        }
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        title = ""
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func bindArticleVM() {
        articleVM.article.subscribe(onNext: { [weak self] article in
            guard let self = self,
                  let article = article else { return }
            
            self.configureUI(article: article)
            self.initLikeIcon()
        }).disposed(by: disposeBag)
    }
    
    
    private func configureUI(article: Article) {
        if let profileImage = article.author.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            self.profileImage.kf.setImage(with: profileImageUrl)
        } else {
            profileImage.image = UIImage(named: "avatar")
        }
        
        authorNameButton.buttonLabel.text = article.author.name
        createdAtLabel.text = DateHelper.getElapsedTime(article.createdAt)
        titleLabel.text = article.title
        contentLabel.text = article.content
        likeCountLabel.text = "\(article.likes.count)"
        commentCountLabel.text = "\(article.commentCount)"
        
        comments = article.comments
        commentTableView.reloadData()
    }
    
    
    private func configureAddTargets() {
        likeIcon.addTarget(self, action: #selector(handleTapLike), for: .touchUpInside)
        commentIcon.addTarget(self, action: #selector(handleTapComment), for: .touchUpInside)
        authorNameButton.addTarget(self, action: #selector(handleTapAuthorNameButton), for: .touchUpInside)
    }
    
    
    private func configureSubViews() {
        [commentTableView, commentContainerView].forEach { view.addSubview($0) }
        
        [profileImage, authorNameButton, createdAtLabel,
         titleLabel, contentLabel, likeIcon, commentIcon,
         likeCountLabel, commentCountLabel, grayDivider].forEach { contentHeaderView.addSubview($0) }
        
        let padding: CGFloat = 20
        
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        grayDivider.backgroundColor = BambooColors.gray
        
        commentContainerView.snp.makeConstraints { make in
            make.height.equalTo(85 + view.safeAreaInsets.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        commentTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(commentContainerView.snp.top)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(30)
            make.width.height.equalTo(40)
        }
        
        authorNameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top).inset(3)
            make.bottom.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(11)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorNameButton.snp.leading)
            make.top.equalTo(authorNameButton.snp.bottom).offset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(createdAtLabel.snp.bottom).offset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        likeIcon.tintColor = BambooColors.gray
        likeIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.width.height.equalTo(22)
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeIcon.snp.trailing).offset(10)
            make.centerY.equalTo(likeIcon.snp.centerY)
        }
        
        commentIcon.tintColor = BambooColors.gray
        commentIcon.iconView.image = UIImage(systemName: "message")
        commentIcon.snp.makeConstraints { make in
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(20)
            make.width.height.equalTo(20)
            make.centerY.equalTo(likeIcon.snp.centerY)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIcon.snp.trailing).offset(10)
            make.centerY.equalTo(commentIcon.snp.centerY)
        }
        
        grayDivider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(likeIcon.snp.bottom).offset(40)
            make.height.equalTo(1)
        }
    }
    
    
    private func configureCommentTableView() {
        commentTableView.backgroundColor = BambooColors.black
        commentTableView.separatorColor = BambooColors.gray
        commentTableView.separatorInset = UIEdgeInsets.zero
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.contentInsetAdjustmentBehavior = .never
        
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseId)
        commentTableView.register(NestedCommentTableViewCell.self, forCellReuseIdentifier: NestedCommentTableViewCell.reuseId)
    }
    
    
    private func configureCommentContainerView() {
        commentContainerView.delegate = self
    }
    
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    private func updateContentHeaderView() {
        contentHeaderView.layoutIfNeeded()
        
        let headerHeight = grayDivider.frame.maxY
        contentHeaderView.frame.size.height = headerHeight
        
        commentTableView.tableHeaderView = contentHeaderView
        commentTableView.tableHeaderView?.layoutIfNeeded()
    }
    
    
    private func configureGestureHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        commentTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc private func dismissKeyboard() {
        commentContainerView.textView.endEditing(true)
        articleVM.updateSelectedCommentId(commentId: nil)
    }

    
    @objc private func handleTapLike() {
        guard let user = userVM.getUser() else { return }
        
        let isLiked = articleVM.checkIsArticleLiked(userId: user.id)
        toggleLike(isLiked)
        
        if isLiked {
            articleVM.deleteLike(userId: user.id)
        } else {
            articleVM.addLike(userId: user.id)
        }
    }
    
    
    @objc private func handleTapComment() {
        commentContainerView.textView.becomeFirstResponder()
    }
    
    
    private func toggleLike(_ isLiked: Bool) {
        if isLiked {
            likeIcon.iconView.image = UIImage(systemName: "heart")
            likeCountLabel.text = "\(max(0, (Int(likeCountLabel.text ?? "0") ?? 0) - 1))"
        } else {
            likeIcon.iconView.image = UIImage(systemName: "heart.fill")
            likeCountLabel.text = "\((Int(likeCountLabel.text ?? "0") ?? 0) + 1)"
        }
    }
    
    
    private func initLikeIcon() {
        guard let user = userVM.getUser() else { return }
        
        let isLiked = articleVM.checkIsArticleLiked(userId: user.id)
        
        if isLiked {
            likeIcon.iconView.image = UIImage(systemName: "heart.fill")
        } else {
            likeIcon.iconView.image = UIImage(systemName: "heart")
        }
    }
    
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let isKeyboardUp = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardHeight = isKeyboardUp ? keyboardFrame.height : 0
        
        commentContainerView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets.bottom).inset(keyboardHeight)
        }
        
        UIView.animate(withDuration: 0, delay: 0,options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTapAuthorNameButton() {
        guard let articleVM = articleVM,
              let author = articleVM.getArticle()?.author,
              let me = userVM.getUser() else { return }
        
        let userProfileVC = UserProfileVC(user: author, me: me)
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
}


extension ArticleDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments[section].nestedComments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseId,
                                                     for: indexPath) as! CommentTableViewCell
            
            cell.delegate = self
            cell.optionButton.tag = indexPath.row
            cell.setCell(comment: comment, userVM: userVM, articleVM: articleVM)
            
            return cell
        } else {
            let nestedComment = comment.nestedComments[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: NestedCommentTableViewCell.reuseId,
                                                     for: indexPath) as! NestedCommentTableViewCell
            
            cell.setCell(comment: nestedComment, userVM: userVM)
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}


extension ArticleDetailVC: CommentContainerDelegate {
    func submitComment(content: String) {
        let selectedCommentId = articleVM.getSelectedCommentId()
        
        NetworkManager.shared.postComment(articleId: selectedArticleId, content: content, parentCommentId: selectedCommentId
        ) { [weak self] in
            guard let self = self else { return }
            
            self.commentContainerView.textView.text = ""
            self.commentContainerView.commentPlaceholder.isHidden = false
            self.commentContainerView.textView.resignFirstResponder()
            self.showToastMessage(message: "댓글이 등록되었습니다", type: .success, direction: .topDown)
            self.articleVM.fetchArticle(articleId: self.selectedArticleId)
            self.articleVM.updateArticleListCommentCount(articleId: self.selectedArticleId, type: "add")
            self.articleVM.updateSelectedCommentId(commentId: nil)
        }
    }
}


extension ArticleDetailVC: CommentCellDelegate {
    func openActionSheet(commentId: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            NetworkManager.shared.deleteComment(commentId: commentId) {
                self.showToastMessage(message: "댓글이 삭제되었습니다", type: .success, direction: .topDown)
                self.articleVM.fetchArticle(articleId: self.selectedArticleId)
                self.articleVM.updateArticleListCommentCount(articleId: self.selectedArticleId, type: "delete")
            }
        })
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    
    func replyComment(commentId: Int) {
        let confirmAlert = UIAlertController(title: "", message: "대댓글을 입력하시겠습니까?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        confirmAlert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.commentContainerView.textView.becomeFirstResponder()
            self.articleVM.updateSelectedCommentId(commentId: commentId)
        })
        
        self.present(confirmAlert, animated: true)
    }
}
