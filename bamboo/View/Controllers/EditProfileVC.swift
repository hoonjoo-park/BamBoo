import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class EditProfileVC: UIViewController {
    let profileImageButton = UIButton()
    let profileImageTitleLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.gray)
    let profileImageView = UIImageView()
    let profileImageDescriptionLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let usernameTitleLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.gray)
    let usernameInput = UIInputView(frame: .zero, inputViewStyle: .keyboard)
    let saveButton = LabelButton(fontSize: 14, weight: .semibold, color: BambooColors.white)
    
    var userVM: UserViewModel!
    let disposeBag = DisposeBag()
    
    init(userVM: UserViewModel!) {
        super.init(nibName: nil, bundle: nil)
        self.userVM = userVM
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSubViews()
        bindUserVM()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "프로필 수정"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: BambooColors.white]
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
    
    
    private func configureSubViews() {
        [profileImageTitleLabel, profileImageView, profileImageDescriptionLabel, usernameTitleLabel, usernameInput, saveButton].forEach {
            view.addSubview($0)
        }
        
        profileImageTitleLabel.text = "프로필 사진 수정"
        profileImageDescriptionLabel.text = "수정을 원하시면, 프로필 사진을 터치 하세요"
        usernameTitleLabel.text = "닉네임 수정"
        saveButton.buttonLabel.text = "변경사항 저장"
        saveButton.backgroundColor = BambooColors.green
        saveButton.layer.cornerRadius = 8
        
        profileImageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(25)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(75)
            make.top.equalTo(profileImageTitleLabel.snp.bottom).offset(45)
        }
        
        profileImageDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        usernameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageDescriptionLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().inset(25)
        }
        
        usernameInput.snp.makeConstraints { make in
            make.top.equalTo(usernameTitleLabel.snp.bottom).offset(25)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(45)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
    }
    
    
    private func bindUserVM() {
        userVM.user.subscribe(onNext: { [weak self] user in
            if let user = user {
                if let profileImage = user.profile.profileImage,
                   let profileImageUrl = URL(string: profileImage) {
                    self?.profileImageView.kf.setImage(with: profileImageUrl)
                }
            }
        }).disposed(by: disposeBag)
    }
}
