import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ArticleDetailVC: UIViewController {
    let disposeBag = DisposeBag()
    var selectedArticleId: Int!
    var articleVM: ArticleVM!
    var comments: [Comment] = []
    
    let profileImage = UIImageView()
    let authorNameLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.gray)
    let titleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let contentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    let likeIcon = UIImageView(image: UIImage(systemName: "heart"))
    let likeCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let commentIcon = UIImageView(image: UIImage(systemName: "message"))
    let commentCountLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let grayDivider = UIView()
    let commentTableView = UITableView(frame: .zero)
    
    
    init(selectedId: Int, articleVM: ArticleVM) {
        self.selectedArticleId = selectedId
        self.articleVM = articleVM
        articleVM.fetchArticle(articleId: selectedId)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BambooColors.black
        configureViewController()
        bindArticleVM()
        configureSubViews()
        configureCommentTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = ""
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.frame.origin.y = view.safeAreaInsets.top
    }
    
    
    private func bindArticleVM() {
        articleVM.article.subscribe(onNext: { [weak self] article in
            guard let article = article else { return }
            
            if let profileImage = article.author.profile.profileImage,
               let profileImageUrl = URL(string: profileImage) {
                self?.profileImage.kf.setImage(with: profileImageUrl)
            }
            
            self?.authorNameLabel.text = article.author.name
            self?.createdAtLabel.text = DateHelper.getElapsedTime(article.createdAt)
            self?.titleLabel.text = article.title
            self?.contentLabel.text = article.content
            self?.likeCountLabel.text = "\(article.likes.count)"
            self?.commentCountLabel.text = "\(article.commentCount)"
            self?.comments = article.comments
            
            self?.commentTableView.reloadData()
        }).disposed(by: disposeBag)
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
            make.width.height.equalTo(24)
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeIcon.snp.trailing).offset(10)
            make.centerY.equalTo(likeIcon.snp.centerY)
        }
        
        commentIcon.tintColor = BambooColors.gray
        commentIcon.snp.makeConstraints { make in
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(20)
            make.width.height.equalTo(21)
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
