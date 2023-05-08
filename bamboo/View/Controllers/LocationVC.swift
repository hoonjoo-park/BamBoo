import UIKit

class LocationVC: UIViewController {
    var fromVC: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    init(fromVC: String!) {
        super.init(nibName: nil, bundle: nil)
        self.fromVC = fromVC
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        view.backgroundColor = BambooColors.black
    }
}
