import UIKit
import SnapKit

class BottomSheetVC: UIViewController {
    let maxBackdropAlpha = 0.6
    var defaultHeight: CGFloat!
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
    
    lazy var titleLabel: BambooLabel = {
        let label = BambooLabel(fontSize: 20, weight: .semibold, color: BambooColors.white)
        return label
    }()
    
    
    init(title: String, height: CGFloat?) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.defaultHeight = height ?? 315
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configureUI()
        configureGestureHandler()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
        animatePresentBackdropView()
    }
    
    
    private func configureUI() {
        [backdropView, containerView].forEach {
            view.addSubview($0)
        }
        
        containerView.addSubview(titleLabel)
        
        backdropView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().offset(defaultHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    
    private func configureGestureHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapBackdrop))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func animatePresentBackdropView() {
        backdropView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backdropView.alpha = self.maxBackdropAlpha
        }
    }
    
    
    func dismissBottomSheet() {
        dismissContainerView()
        dismissBackdropView()
    }
    
    
    private func dismissContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(self.defaultHeight)
            }
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
        dismissBottomSheet()
    }
}
