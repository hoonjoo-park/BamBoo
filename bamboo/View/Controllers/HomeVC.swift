import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeVC: ToastMessageVC {
    enum Section { case main }
    
    var userVM: UserViewModel!
    var articleVM: ArticleVM!
    let disposeBag = DisposeBag()
    let homeHeaderView = HomeHeaderView(frame: .zero)
    var articleListCollectionView: ArticleListCollectionView!
    
    init(userVM: UserViewModel, articleVM: ArticleVM) {
        self.userVM = userVM
        self.articleVM = articleVM
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureUI()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = BambooColors.black
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureViewController() {
        articleListCollectionView = ArticleListCollectionView(frame: .zero,
                                                              collectionViewLayout: CollectionViewHelper.createArticleListFlowLayout(view: view))
        articleListCollectionView.backgroundColor = BambooColors.black
        articleListCollectionView.register(ArticleListCollectionViewCell.self, forCellWithReuseIdentifier: ArticleListCollectionViewCell.reuseId)
    }
    
    
    private func configureUI() {
        [homeHeaderView, articleListCollectionView].forEach {
            view.addSubview($0)
        }
        
        homeHeaderView.delegate = self
        
        homeHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        articleListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(homeHeaderView.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        articleVM.articleLists
            .bind(to: articleListCollectionView.rx.items(cellIdentifier: ArticleListCollectionViewCell.reuseId,
                                                         cellType: ArticleListCollectionViewCell.self)) { row, articleList, cell in
                guard let articleList = articleList else { return }
                
                cell.setCell(articleList: articleList)
            }.disposed(by: disposeBag)
        
        articleListCollectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let selectedArticleList = self?.articleVM.getSelectedArticleList(index: indexPath[1]),
                      let articleVM = self?.articleVM,
                      let userVM = self?.userVM else { return }
                
                let articleDetailVC = ArticleDetailVC(selectedId: selectedArticleList.id,
                                                      articleVM: articleVM, userVM: userVM)
                articleDetailVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(articleDetailVC, animated: true)
            }.disposed(by: disposeBag)
    }
}

extension HomeVC: HomeHeaderViewDelegate {
    func openLocationBottomSheet() {
        let locationVC = LocationVC(fromVC: "HomeVC")
        locationVC.modalPresentationStyle = .overFullScreen
        locationVC.delegate = self
        
        present(locationVC, animated: false)
    }
}

extension HomeVC: LocationVCDelegate {
    func saveSelectedLocation(cityName: String, districtName: String) {
        homeHeaderView.loacationLabel.text = "\(cityName), \(districtName)"
        showToastMessage(message: "위치 설정이 완료되었습니다!", type: .success, direction: .topDown)
    }
}
