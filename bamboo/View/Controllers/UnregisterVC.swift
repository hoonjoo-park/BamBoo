import UIKit
import SnapKit

class UnregisterVC: UIViewController {
    var userVM: UserViewModel!
    
    let descriptionLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.white)
    let confirmLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.white)
    let unregisterButton = LabelButton(fontSize: 14, weight: .semibold, color: BambooColors.white)
    
    
    init(userVM: UserViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.userVM = userVM
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "회원 탈퇴"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.frame.origin.y = view.safeAreaInsets.top
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 25
        
        [descriptionLabel, confirmLabel, unregisterButton].forEach {
            view.addSubview($0)
        }
        
        descriptionLabel.text = "회원 탈퇴 시 유저님의 모든 데이터가 삭제 되며,\n삭제된 데이터는 복구할 수 없습니다."
        confirmLabel.text = "회원 탈퇴를 원하시면 아래 버튼을 눌러주세요"
        unregisterButton.buttonLabel.text = "회원 탈퇴"
        
        unregisterButton.layer.cornerRadius = 8
        unregisterButton.backgroundColor = BambooColors.pink
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(padding)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(padding)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(13)
        }
        
        unregisterButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(padding)
            make.top.equalTo(confirmLabel.snp.bottom).offset(40)
            make.height.equalTo(45)
        }
        
        unregisterButton.addTarget(self, action: #selector(handleUnregisterTap), for: .touchUpInside)
    }
    
    
    @objc private func handleUnregisterTap() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { [weak self] action in
            self?.unregisterUser()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    private func unregisterUser() {
        NetworkManager.shared.deleteUser {
            UserDefaults.standard.removeToken()
        }
    }
}
