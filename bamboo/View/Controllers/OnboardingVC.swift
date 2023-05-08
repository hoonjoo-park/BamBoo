import UIKit
import SnapKit

class OnboardingVC: UIViewController {
    let welcomeTitleLabel = BambooLabel(fontSize: 24, weight: .bold, color: BambooColors.white)
    let welcomeDescriptionLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    let startButton = LabelButton(fontSize: 18, weight: .bold, color: BambooColors.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureUI()
        configureButtonTarget()
    }
    
    
    private func configureLabels() {
        welcomeTitleLabel.text = "뱀부에 오신 걸 환영해요"
        welcomeDescriptionLabel.text = "캠퍼스에만 조성되어 있던 대나무숲이 울거져 나왔어요!"
        startButton.buttonLabel.text = "시작하기"
    }
    
    
    private func configureUI() {
        view.backgroundColor = BambooColors.black
        
        [startButton, welcomeDescriptionLabel, welcomeTitleLabel].forEach { view.addSubview($0) }
        
        startButton.layer.cornerRadius = 25
        startButton.backgroundColor = BambooColors.green
        
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(194)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(75)
        }
        
        welcomeDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top).offset(-75)
            $0.horizontalEdges.equalToSuperview().inset(45)
        }
        
        welcomeTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(welcomeDescriptionLabel.snp.top).offset(-35)
        }
    }
    
    
    private func configureButtonTarget() {
        startButton.addTarget(self, action: #selector(openLoginBottomSheet), for: .touchUpInside)
    }
    
    
    @objc func openLoginBottomSheet() {
        let loginVC = LoginVC(title:"로그인", height: nil)
        loginVC.modalPresentationStyle = .overCurrentContext
        
        present(loginVC, animated: false)
    }
}
