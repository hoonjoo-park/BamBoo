import UIKit
import RxSwift
import RxCocoa

class ArticleDetailVC: UIViewController {
    let disposeBag = DisposeBag()
    var selectedArticleId: Int!
    var articleVM: ArticleVM!
    
    init(selectedId: Int, articleVM: ArticleVM) {
        self.selectedArticleId = selectedId
        self.articleVM = articleVM
        
        super.init(nibName: nil, bundle: nil)
        
        NetworkManager.shared.fetchArticle(articleId: selectedId)
            .subscribe(onNext: { [weak self] article in
                print(article)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BambooColors.black
        configureViewController()
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
}
