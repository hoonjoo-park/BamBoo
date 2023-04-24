import UIKit

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
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 195),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            
            welcomeDescriptionLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -75),
            welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 45),
            
            welcomeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeTitleLabel.bottomAnchor.constraint(equalTo: welcomeDescriptionLabel.topAnchor, constant: -35),
        ])
    }
    
    
    private func configureButtonTarget() {
        startButton.addTarget(self, action: #selector(openLoginBottomSheet), for: .touchUpInside)
    }
    
    
    @objc func openLoginBottomSheet() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .overCurrentContext
        
        present(loginVC, animated: false)
    }
}
