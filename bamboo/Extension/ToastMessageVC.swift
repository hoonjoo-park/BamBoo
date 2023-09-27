import UIKit

class ToastMessageVC: UIViewController {
    var toastMessageView: ToastMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func showToastMessage(message: String, type: ToastMessageType, direction: ToastMessageDirection) {
        let toastMessageHeight = 50
        let toastMessageWidth = Int(view.frame.width - 30)
        let viewHeight = Int(view.frame.height)
        let centerX = (Int(view.frame.width) - toastMessageWidth) / 2
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let safeAreaTop = Int(view.safeAreaInsets.top)
        let safeAreaBottom = Int(view.safeAreaInsets.bottom)
        
        toastMessageView = ToastMessageView(message: message, type: type)
        
        var startFrame: CGRect
        var finishFrame: CGRect
        
        switch direction {
        case .topDown:
            startFrame = CGRect(x: centerX,
                                y: -toastMessageHeight,
                                width: toastMessageWidth,
                                height: toastMessageHeight)
            finishFrame = CGRect(x: centerX,
                                 y: safeAreaTop,
                                 width: toastMessageWidth,
                                 height: toastMessageHeight)
            break
        case .bottomUp:
            startFrame = CGRect(x: centerX,
                                y: viewHeight,
                                width: toastMessageWidth,
                                height: toastMessageHeight)
            finishFrame = CGRect(x: centerX,
                                 y: viewHeight - toastMessageHeight - safeAreaBottom,
                                 width: toastMessageWidth,
                                 height: toastMessageHeight)
            break
        }
        
        toastMessageView.frame = startFrame
        self.navigationController?.view.addSubview(toastMessageView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.toastMessageView.frame = finishFrame
        }) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.toastMessageView.frame = startFrame
                }) { _ in
                    self?.toastMessageView.removeFromSuperview()
                }
            }
        }
    }
}
