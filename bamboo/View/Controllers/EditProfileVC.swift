import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import Photos

class EditProfileVC: UIViewController {
    let profileImageTitleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.gray)
    let profileImageView = UIImageView()
    let profileImageDescriptionLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.gray)
    let usernameTitleLabel = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.gray)
    let usernameInput = UITextField()
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeborderBottom(superView: usernameInput, height: 1, color: BambooColors.darkGray.cgColor)
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        profileImageView.layer.cornerRadius = 37.5
        profileImageView.clipsToBounds = true
        profileImageTitleLabel.text = "프로필 사진 수정"
        profileImageDescriptionLabel.text = "수정을 원하시면, 프로필 사진을 터치 하세요"
        usernameTitleLabel.text = "닉네임 수정"
        saveButton.buttonLabel.text = "변경사항 저장"
        usernameInput.placeholder = "닉네임을 입력해 주세요"
        saveButton.backgroundColor = BambooColors.green
        saveButton.layer.cornerRadius = 8
        
        saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        
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
            guard let self = self else { return }
            
            if let user = user {
                if let profileImage = user.profile.profileImage,
                   let profileImageUrl = URL(string: profileImage) {
                    self.profileImageView.kf.setImage(with: profileImageUrl)
                } else {
                    self.profileImageView.image = UIImage(named: "avatar")
                }
                
                self.usernameInput.text = user.profile.username
            }
        }).disposed(by: disposeBag)
    }
    
    
    @objc private func handleProfileImageTapped() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentImagePickerController()
                    } else {
                        self?.presentPhotoLibraryDeniedAlert(message: "사진첩 접근 권한이 차단되었습니다.")
                    }
                }
            }
        case .denied, .restricted:
            presentPhotoLibraryDeniedAlert(message: "사진첩 접근 권한 허용을 원하신다면, '설정 -> 뱀부 -> 사진 접근권한 변경' 절차를 따라 주세요.")
            break
        default:
            break
        }
    }
    
    
    private func presentImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    private func presentPhotoLibraryDeniedAlert(message: String) {
        let alert = UIAlertController(title: "사진첩 접근 불가", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func handleSaveButtonTapped() {
        let confirm = UIAlertController(title: "저장하시겠습니까?", message: "확인 버튼을 누르시면 변경 사항이 저장됩니다.", preferredStyle: .alert)
        
        confirm.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] action in
            guard let self = self,
                  let username = self.usernameInput.text,
                  let image = self.profileImageView.image,
                  let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            
            NetworkManager.shared.putUser(profileImage: imageData, username: username) { profile in
                guard let profile = profile else { return }
                
                self.userVM.updateProfile(profile)
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        confirm.addAction(UIAlertAction(title: "취소", style: .destructive))
        
        present(confirm, animated: true)
    }
}


extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
