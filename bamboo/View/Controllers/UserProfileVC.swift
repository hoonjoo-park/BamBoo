import UIKit
import SnapKit
import Kingfisher
import RxSwift

class UserProfileVC: UIViewController {
    var selectedUser: User!
    var meId: Int!
    
    let disposeBag = DisposeBag()
    let profileImageView = UIImageView()
    let emailLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    let createdAtLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    let chatButton = UIButton()
    let chatIconView = UIImageView(image: UIImage(systemName: "message"))
    let chatButtonLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.white)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
    }
    
    
    init(author: User, meId: Int) {
        self.selectedUser = author
        self.meId = meId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        title = selectedUser.name
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func configureUI() {
        [profileImageView, emailLabel, createdAtLabel].forEach { subView in
            view.addSubview(subView)
        }
        
        if let profileImage = selectedUser.profile.profileImage, let profileImageUrl = URL(string: profileImage) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
        
        emailLabel.text = selectedUser.email
        createdAtLabel.text = DateHelper.getElapsedTime(selectedUser.createdAt)
        
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
        
        if selectedUser.id != meId {
            configureChatButton()
        }
    }
    
    private func configureChatButton() {
        self.view.addSubview(chatButton)
        
        [chatIconView, chatButtonLabel].forEach { subView in
            chatButton.addSubview(subView)
        }
        
        chatButtonLabel.text = "1:1 채팅하기"
        chatIconView.tintColor = BambooColors.white
        chatButton.addTarget(self, action: #selector(handlePressChat), for: .touchUpInside)
        
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
    
    private func bindViewModel() {
        ChatRoomViewModel.shared.createdChatRoomSubject.subscribe(onNext: { chatRoom in
            guard let newChatRoom = chatRoom else { return }
            
            let chatRoomVC = ChatVC(chatRoom: newChatRoom)
            self.navigationController?.pushViewController(chatRoomVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @objc private func handlePressChat() {
        let existingChatRoom = ChatRoomViewModel.shared.checkHasChatRoomWithOponent(opponentId: selectedUser.id)
        
        guard let existingChatRoom = existingChatRoom else {
            SocketIOManager.shared.createChatRoom(userId: selectedUser.id)
            return
        }
        
        let chatRoomVC = ChatVC(chatRoom: existingChatRoom)
        navigationController?.pushViewController(chatRoomVC, animated: true)
    }
}
