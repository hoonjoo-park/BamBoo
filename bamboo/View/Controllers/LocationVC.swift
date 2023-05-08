import UIKit

class LocationVC: BottomSheetVC {
    var fromVC: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    init(fromVC: String!) {
        super.init(title: "위치 설정", height: CGFloat(500))
        self.fromVC = fromVC
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
