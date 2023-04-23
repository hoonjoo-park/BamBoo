import UIKit

class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = BambooColors.white
        UITabBar.appearance().unselectedItemTintColor = BambooColors.gray
        UITabBar.appearance().backgroundColor = BambooColors.navy
        
        viewControllers = [createHomeVC(), createWritePostVC(), createMyPageVC()]
    }
    
    
    private func createHomeVC() -> UINavigationController {
        let homeVC = HomeVC()
        let tabBarImage: UIImage!
        
        tabBarImage = UIImage(systemName: "house")
        
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 0)
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func createWritePostVC() -> UINavigationController {
        let writePostVC = WritePostVC()
        let tabBarImage: UIImage!

        tabBarImage = UIImage(systemName: "plus.circle")
        tabBarImage.withTintColor(BambooColors.green)
        
        
        writePostVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 1)
        
        return UINavigationController(rootViewController: writePostVC)
    }
    
    private func createMyPageVC() -> UINavigationController {
        let myPageVC = MyPageVC()
        let tabBarImage: UIImage!
        
        tabBarImage = UIImage(systemName: "person")
        
        myPageVC.tabBarItem = UITabBarItem(title: "", image: tabBarImage, tag: 2)
        
        return UINavigationController(rootViewController: myPageVC)
    }
}

