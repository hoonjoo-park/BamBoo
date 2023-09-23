import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageWithRetry(url: URL, retry: Int) {
        let kingfisher = KingfisherManager.shared
        
        kingfisher.retrieveImage(with: url) { result in
            switch result {
            case .success:
                self.kf.setImage(with: url)
                break
                
            case .failure(let error):
                print("setImageWithRetry error: \(error)")
                
                guard retry > 0 else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.setImageWithRetry(url: url, retry: retry - 1)
                }
                break
            }
        }
    }
}
