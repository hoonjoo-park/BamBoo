import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ChatRoomsVC: UIViewController {
    let disposeBag = DisposeBag()
    var userVM: UserViewModel!
    
    var chatRoomListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        bindChatRoomVM()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "채팅 목록"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
    }
    
    
    init(userVM: UserViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.userVM = userVM
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = BambooColors.black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.frame.origin.y = view.safeAreaInsets.top
        
        chatRoomListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewHelper.createChatRoomListFlowLayout(view: view))
        chatRoomListCollectionView.backgroundColor = BambooColors.black
        chatRoomListCollectionView.register(ChatRoomListCollectionViewCell.self, forCellWithReuseIdentifier: ChatRoomListCollectionViewCell.reuseId)
        
        view.addSubview(chatRoomListCollectionView)
        
        chatRoomListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    private func bindChatRoomVM() {
        ChatRoomViewModel.shared.chatRooms.bind(to: chatRoomListCollectionView.rx.items(cellIdentifier: ChatRoomListCollectionViewCell.reuseId,
                                                                          cellType: ChatRoomListCollectionViewCell.self)) { row, chatRoom, cell in
            guard let chatRoom = chatRoom else { return }
            
            cell.setCell(chatRoom: chatRoom)
        }.disposed(by: disposeBag)
    }
}
