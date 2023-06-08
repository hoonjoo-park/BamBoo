import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ArticleDetailVC: UIViewController {
    let disposeBag = DisposeBag()
    var selectedArticleId: Int!
    var articleVM: ArticleVM!
    var userVM: UserViewModel!
    var comments: [Comment] = []
    
    let profileImage = UIImageView()
    let authorNameLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.gray)
    let titleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let contentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    let likeIcon = IconButton(frame: .zero)
    let likeCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let commentIcon = IconButton(frame: .zero)
    let commentCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let grayDivider = UIView()
    let commentTableView = UITableView(frame: .zero)
    
    
    init(selectedId: Int, articleVM: ArticleVM, userVM: UserViewModel) {
        self.selectedArticleId = selectedId
        self.articleVM = articleVM
        self.userVM = userVM
        articleVM.fetchArticle(articleId: selectedId)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLikeIcon()
        bindArticleVM()
        configureAddTargets()
        configureSubViews()
        configureCommentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewController()
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        title = ""
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.frame.origin.y = view.safeAreaInsets.top
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func bindArticleVM() {
        articleVM.article.subscribe(onNext: { [weak self] article in
            guard let self = self,
                  let article = article else { return }
            
            self.configureUI(article: article)
        }).disposed(by: disposeBag)
    }
    
    
    private func configureUI(article: Article) {
        if let profileImage = article.author.profile.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            self.profileImage.kf.setImage(with: profileImageUrl)
        }
        
        authorNameLabel.text = article.author.name
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
    }
    
    
    private func configureSubViews() {
        [profileImage, authorNameLabel, createdAtLabel,
         titleLabel, contentLabel, likeIcon, commentIcon,
         likeCountLabel, commentCountLabel, grayDivider,
         commentTableView].forEach { view.addSubview($0) }
        
        let padding: CGFloat = 20
        
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        grayDivider.backgroundColor = BambooColors.gray
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.width.height.equalTo(40)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top).inset(3)
            make.leading.equalTo(profileImage.snp.trailing).offset(11)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorNameLabel.snp.leading)
            make.top.equalTo(authorNameLabel.snp.bottom).offset(5)
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
        
        commentTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(grayDivider.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
        // TODO: 구현 예정
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
            cell.setCell(comment: comment)
            
            return cell
        } else {
            let nestedComment = comment.nestedComments[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: NestedCommentTableViewCell.reuseId,
                                                     for: indexPath) as! NestedCommentTableViewCell
            cell.setCell(comment: nestedComment)
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
