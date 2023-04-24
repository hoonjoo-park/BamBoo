import UIKit

class LoginVC: UIViewController {
    let maxBackdropAlpha = 0.6
    let defaultHeight: CGFloat = 315
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = BambooColors.navy
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    lazy var backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = BambooColors.black
        view.alpha = maxBackdropAlpha
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGestureHandler()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
        animatePresentBackdropView()
    }
    
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        [backdropView, containerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    
    private func configureGestureHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapBackdrop))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func animatePresentBackdropView() {
        backdropView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backdropView.alpha = self.maxBackdropAlpha
        }
    }
    
    
    private func dismissContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func dismissBackdropView() {
        backdropView.alpha = maxBackdropAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.backdropView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    
    @objc func handleTapBackdrop() {
        dismissContainerView()
        dismissBackdropView()
    }
}
