import UIKit

class WritePostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: BambooColors.white]
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(closeButtonTapped))
        let postButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(postButtonTapped))
        
        postButton.tintColor = BambooColors.green
        
        view.backgroundColor = BambooColors.black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = postButton
    }
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func postButtonTapped() {
        print("post button tapped!")
    }
}
