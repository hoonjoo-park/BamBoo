import UIKit

enum BambooColors {
    static let black = UIColor(r: 28, g: 26, b: 29, a: 1)
    static let pureBlack = UIColor(r: 0, g: 0, b: 0, a: 1)
    static let white = UIColor(r: 255, g: 255, b: 255, a: 1)
    static let navy = UIColor(r: 31, g: 31, b: 41, a: 1)
    static let lightNavy = UIColor(r: 51, g: 51, b: 64, a: 1)
    static let green = UIColor(r: 62, g: 183, b: 120, a: 1)
    static let gray = UIColor(r: 138, g: 138, b: 140, a: 1)
    static let darkGray = UIColor(r: 90, g: 90, b: 90, a: 1)
    static let kakaoYello = UIColor(r: 254, g: 225, b: 2, a: 1)
    static let pink = UIColor(r: 242, g: 78, b: 117, a: 1)
}

enum ToastMessageType {
    case success
    case failed
    case warn
}

enum ToastMessageDirection {
    case topDown
    case bottomUp
}


func makeborderBottom(superView: UIView, height: CGFloat, color: CGColor) {
    let borderBottom = CALayer()
    borderBottom.frame = CGRect(x: 0, y: superView.frame.size.height, width: superView.frame.size.width, height: height)
    borderBottom.backgroundColor = color
    superView.layer.addSublayer(borderBottom)
}

enum CollectionViewHelper {
    static func createArticleListFlowLayout(view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let viewWidth = view.bounds.width
        let padding: CGFloat = 30
        let itemSpacing: CGFloat = 20
        let itemWidth = viewWidth - (padding * 2)
        
        flowLayout.sectionInset = UIEdgeInsets(top: itemSpacing, left: 0, bottom: itemSpacing, right: 0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 100)
        
        return flowLayout
    }
}
