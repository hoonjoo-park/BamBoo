
import UIKit
import SnapKit
import Kingfisher

class UserProfileVC: UIViewController {
    var currentUser: User!
    
    let profileImageView = UIImageView()
    let emailLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    let chatButton = UIButton()
    let chatIconView = UIImageView(image: UIImage(systemName: "message"))
    let chatButtonLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.white)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
    }
    
    
    init(user: User) {
        currentUser = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        title = currentUser.name
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func configureUI() {
        [profileImageView, emailLabel, createdAtLabel, chatButton].forEach { subView in
            view.addSubview(subView)
        }
        
        [chatIconView, chatButtonLabel].forEach { subView in
            chatButton.addSubview(subView)
        }
        
        if let profileImage = currentUser.profile.profileImage, let profileImageUrl = URL(string: profileImage) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
        
        emailLabel.text = currentUser.email
        createdAtLabel.text = DateHelper.getElapsedTime(currentUser.createdAt)
        chatButtonLabel.text = "1:1 채팅하기"
        chatIconView.tintColor = BambooColors.white
        
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(25)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).inset(10)
            make.leading.equalTo(emailLabel.snp.leading)
        }
        
        chatButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        chatIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
        }
        
        chatButtonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(chatIconView.snp.trailing).offset(15)
        }
    }
}
