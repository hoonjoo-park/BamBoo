import UIKit
import SnapKit

class HomeVC: ToastMessageVC {
    var userVM: UserViewModel!
    let homeHeaderView = HomeHeaderView(frame: .zero)
    var articleListCollectionView: ArticleListCollectionView!
    
    init(userVM: UserViewModel!) {
        super.init(nibName: nil, bundle: nil)
        self.userVM = userVM
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureUI()
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
        showToastMessage(message: "위치 설정이 완료되었습니다!", type: .success, dirction: .topDown)
    }
}
