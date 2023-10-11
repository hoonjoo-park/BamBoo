import UIKit
import RxSwift

class RootTabBarController: UITabBarController {
    var userVM: UserViewModel
    let articleVM = ArticleVM()
    let disposeBag = DisposeBag()
    
    init(userVM: UserViewModel) {
        self.userVM = userVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationVM.shared.fetchLocations()
        articleVM.fetchArticleList(cityId: -1, districtId: -1)
        
        delegate = self
        UITabBar.appearance().tintColor = BambooColors.white
        UITabBar.appearance().unselectedItemTintColor = BambooColors.gray
        UITabBar.appearance().backgroundColor = BambooColors.navy
        
        viewControllers = [createHomeVC(), createDummySecondVC(), createMyPageVC()]
    }
    
    
    private func createHomeVC() -> UINavigationController {
        let homeVC = HomeVC(userVM: userVM, articleVM: articleVM)
        let tabBarImage: UIImage!
        
        tabBarImage = UIImage(systemName: "house")?.withBaselineOffset(fromBottom: 15)
        homeVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 0)
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createDummySecondVC() -> UIViewController {
        let dummyVC = UIViewController()
        let tabBarImage: UIImage!
        
        tabBarImage = UIImage(systemName: "plus.circle")?.withTintColor(BambooColors.green, renderingMode: .alwaysOriginal)
            .withBaselineOffset(fromBottom: 15)
        dummyVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 1)
        
        return dummyVC
    }
    
    
    private func createMyPageVC() -> UINavigationController {
        let myPageVC = MyPageVC(userVM: userVM)
        let tabBarImage: UIImage!
        
        tabBarImage = UIImage(systemName: "person")?.withBaselineOffset(fromBottom: 15)
        myPageVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 2)
        
        return UINavigationController(rootViewController: myPageVC)
    }
    
    
    private func presentWriteArticleVC() {
        let writeArticleVC = WriteArticleVC(articleVM: articleVM)
        let navigationController = UINavigationController(rootViewController: writeArticleVC)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        
        present(navigationController, animated: true, completion: nil)
    }
}


extension RootTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == viewControllers?[1] {
            presentWriteArticleVC()
            return false
        }
        return true
    }
}
