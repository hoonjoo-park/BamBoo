import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ArticleDetailVC: UIViewController {
    let disposeBag = DisposeBag()
    var selectedArticleId: Int!
    var articleVM: ArticleVM!
    
    let profileImage = UIImageView()
    let authorNameLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 10, weight: .medium, color: BambooColors.gray)
    let titleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let contentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.white)
    let likeIcon = UIImageView(image: UIImage(systemName: "heart"))
    let likeLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let commentIcon = UIImageView(image: UIImage(systemName: "message"))
    let commentLabel = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    
    init(selectedId: Int, articleVM: ArticleVM) {
        self.selectedArticleId = selectedId
        self.articleVM = articleVM
        
        super.init(nibName: nil, bundle: nil)
        
        NetworkManager.shared.fetchArticle(articleId: selectedId)
            .subscribe(onNext: { [weak self] article in
                if let profileImage = article.author.profile.profileImage,
                   let profileImageUrl = URL(string: profileImage) {
                    self?.profileImage.kf.setImage(with: profileImageUrl)
                }
                
                self?.authorNameLabel.text = article.author.name
                self?.createdAtLabel.text = DateHelper.getElapsedTime(article.createdAt)
                self?.titleLabel.text = article.title
                self?.contentLabel.text = article.content
                self?.likeLabel.text = "\(article.likes.count)"
                self?.commentLabel.text = "\(article.comments.count)"
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BambooColors.black
        configureViewController()
        configureSubViews()
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
    
    
    private func configureSubViews() {
        [profileImage, authorNameLabel, createdAtLabel,
         titleLabel, contentLabel, likeIcon, commentIcon,
         likeLabel, commentLabel].forEach { view.addSubview($0) }
        
        let padding: CGFloat = 20
        
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(35)
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
        
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeIcon.snp.trailing).offset(10)
            make.centerY.equalTo(likeIcon.snp.centerY)
        }
        
        commentIcon.tintColor = BambooColors.gray
        commentIcon.snp.makeConstraints { make in
            make.leading.equalTo(likeLabel.snp.trailing).offset(20)
            make.width.height.equalTo(21)
            make.centerY.equalTo(likeIcon.snp.centerY)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentIcon.snp.trailing).offset(10)
            make.centerY.equalTo(commentIcon.snp.centerY)
        }
    }
}
