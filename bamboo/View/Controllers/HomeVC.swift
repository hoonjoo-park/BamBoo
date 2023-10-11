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
    let emptyView = ArticleListEmptyView()
    var articleListCollectionView: ArticleListCollectionView!
    
    init(userVM: UserViewModel, articleVM: ArticleVM) {
        self.userVM = userVM
        self.articleVM = articleVM
        
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindLocationVM()
        configureViewController()
        configureSubViews()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = BambooColors.black
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureViewController() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleProfileUpdatedNotification),
                                               name: NotificationName.profileUpdated,
                                               object: nil)
        
        articleListCollectionView = ArticleListCollectionView(frame: .zero,
                                                              collectionViewLayout: CollectionViewHelper.createArticleListFlowLayout(view: view))
        articleListCollectionView.backgroundColor = BambooColors.black
        articleListCollectionView.register(ArticleListCollectionViewCell.self, forCellWithReuseIdentifier: ArticleListCollectionViewCell.reuseId)
    }
    
    
    private func configureSubViews() {
        emptyView.isHidden = true
        homeHeaderView.delegate = self
        
        [homeHeaderView, articleListCollectionView, emptyView].forEach {
            view.addSubview($0)
        }
        
        homeHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        articleListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(homeHeaderView.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(homeHeaderView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    
    private func bindLocationVM() {
        LocationVM.shared.selectedFilterLocation.subscribe(onNext: { [weak self] selectedLoacation in
            guard let self = self else { return }
            
            self.articleVM.fetchArticleList(cityId: selectedLoacation?.cityId ?? -1,
                                            districtId: selectedLoacation?.districtId ?? -1)
            
        }).disposed(by: disposeBag)
    }
    
    
    private func configureCollectionView() {
        articleVM.articleLists.do(onNext: {[weak self] lists in
            guard let self = self else { return }
            
            self.emptyView.isHidden = !lists.isEmpty
        }).bind(to: articleListCollectionView.rx.items(cellIdentifier: ArticleListCollectionViewCell.reuseId,
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
    
    @objc private func handleProfileUpdatedNotification() {
        let selectedLocation = LocationVM.shared.selectedFilterLocation.value
        
        articleVM.fetchArticleList(cityId: selectedLocation?.cityId ?? -1, districtId: selectedLocation?.districtId ?? -1)
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
