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
    
    static func createChatRoomListFlowLayout(view: UIView) -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let viewWidth = view.bounds.width
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: viewWidth, height: 60)
        
        return flowLayout
    }
}

enum DateHelper {
    static func getElapsedTime(_ createdAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: createdAt) else { return "" }
        
        let calendar = Calendar.current
        let now = Date()
        let dateComponents = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        guard let minute = dateComponents.minute,
              let hour = dateComponents.hour,
              let day = dateComponents.day else { return "" }
        
        if day >= 7 {
            dateFormatter.dateFormat = "yy.MM.dd"
            return dateFormatter.string(from: date)
        }
        
        if day >= 1 {
            return "\(day)일 전"
        }
        
        if hour >= 1, hour < 24 {
            return "\(hour)시간 전"
        }
        
        if minute >= 1, minute < 60 {
            return "\(minute)분 전"
        }
        
        if minute < 1 {
            return "방금"
        }
        
        return ""
    }
}
