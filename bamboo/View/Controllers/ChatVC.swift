import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChatVC: UIViewController {
    var currentChatRoom: ChatRoom!
    let chatVM = ChatViewModel.shared
    let disposeBag = DisposeBag()
    
    var chatCollectionView: UICollectionView!
    let bottomContainer = UIView(frame: .zero)
    let messageInputContainer = UIView(frame: .zero)
    let messageInput = MessageTextView()
    let sendButton = UIButton(frame: .zero)
    let sendIcon = UIImageView(image: UIImage(systemName: "arrow.up"))
    let placeHolder = BambooLabel(fontSize: 14, weight: .regular, color: BambooColors.gray)
    let inputPlaceHolderText = "메시지를 입력해 주세요"
    
    init(chatRoom: ChatRoom) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentChatRoom = chatRoom
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ChatRoomViewModel.shared.createdChatRoomSubject.accept(nil)
        configureNavigation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewHelper.createChatFlowLayout(view: view))
        chatCollectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.reuseId)
        chatCollectionView.backgroundColor = BambooColors.black
        bindChatVM()
        
        configureViewController()
        configureKeyboardNotification()
    }
    
    
    
    private func configureNavigation() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        title = currentChatRoom.senderProfile.username
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    private func configureViewController() {
        messageInput.delegate = self
        placeHolder.text = inputPlaceHolderText
        
        [chatCollectionView, bottomContainer].forEach { view.addSubview($0) }
        bottomContainer.addSubview(messageInputContainer)
        [messageInput, sendButton, placeHolder].forEach { messageInputContainer.addSubview($0) }
        sendButton.addSubview(sendIcon)
        
        bottomContainer.backgroundColor = BambooColors.navy
        messageInputContainer.layer.cornerRadius = 22.5
        messageInputContainer.backgroundColor = BambooColors.black
        messageInput.backgroundColor = BambooColors.black
        sendButton.backgroundColor = BambooColors.green
        sendButton.layer.cornerRadius = 15
        sendIcon.tintColor = BambooColors.white
        
        
        chatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomContainer.snp.top)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(85)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        messageInputContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(47)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        messageInput.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalTo(sendButton.snp.leading).offset(-15)
            make.verticalEdges.equalToSuperview()
        }
        
        sendIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        placeHolder.snp.makeConstraints { make in
            make.leading.equalTo(messageInput.snp.leading).inset(5)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    
    private func bindChatVM() {
        chatVM.chatMessages.bind(to: chatCollectionView.rx.items(
            cellIdentifier: ChatCollectionViewCell.reuseId,
            cellType: ChatCollectionViewCell.self)) {  row, chatMessage, cell in
                guard let chatMessage = chatMessage else { return }
                
                cell.setCell(message: chatMessage)
            
        }.disposed(by: disposeBag)
    }
    
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let isKeyboardUp = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardHeight = isKeyboardUp ? keyboardFrame.height : 0
        
        bottomContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets.bottom).inset(keyboardHeight)
        }
        
        UIView.animate(withDuration: 0, delay: 0,options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatVC: UITextViewDelegate {
    var lineHeight: CGFloat {
        return messageInput.font?.lineHeight ?? 0
    }
    
    var maxNumberOfLines: CGFloat {
        return 7
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxSize = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(maxSize)
        let maximumHeight = lineHeight * maxNumberOfLines
        
        placeHolder.isHidden = !textView.text.isEmpty
        
        messageInputContainer.snp.updateConstraints { make in
            make.height.equalTo(min(estimatedSize.height, maximumHeight))
        }
        
        bottomContainer.snp.updateConstraints { make in
            make.height.equalTo(min(38 + maximumHeight, 38 + estimatedSize.height))
        }
        
        textView.isScrollEnabled = estimatedSize.height > maximumHeight
    }
}
