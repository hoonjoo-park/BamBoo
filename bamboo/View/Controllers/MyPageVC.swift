import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class MyPageVC: UIViewController {
    private let tableView = UITableView(frame: .zero)
    private let headerView = UIView()
    private let listTitles = ["채팅", "로그아웃", "회원 탈퇴", "버전 정보"]
    let profileImage = UIImageView(image: UIImage(named: "panda"))
    let usernameLabel = BambooLabel(fontSize: 18, weight: .semibold, color: BambooColors.white)
    let profileEditButton = UIButton()
    let editIcon = UIImageView(image: UIImage(systemName: "square.and.pencil"))
    let editLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
    
    var userVM: UserViewModel!
    let disposeBag = DisposeBag()
    
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
        configureHeaderView()
        configureTableView()
        bindUserVM()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureViewController() {
        view.backgroundColor = BambooColors.black
        navigationController?.isNavigationBarHidden = true
        view.addSubview(tableView)
    }
    
    
    private func configureHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        editIcon.tintColor = BambooColors.gray
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        
        [profileImage, usernameLabel, profileEditButton].forEach {
            headerView.addSubview($0)
        }
        
        [editIcon, editLabel].forEach {
            profileEditButton.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }
        
        profileEditButton.addTarget(self, action: #selector(handleTapEditButton), for: .touchUpInside)
        profileEditButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.trailing.equalToSuperview().inset(25)
        }
        
        editIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        editLabel.text = "프로필 수정"
        editLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(editIcon.snp.trailing).offset(7)
        }
    }
    
    
    private func configureTableView() {
        tableView.backgroundColor = BambooColors.black
        tableView.separatorColor = BambooColors.gray
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseId)
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindUserVM() {
        userVM.user
            .subscribe(onNext: {  [weak self] user in
                if let user = user {
                    if let profileImage = user.profile.profileImage,
                       let profileImageUrl = URL(string: profileImage) {
                        self?.profileImage.kf.setImage(with: profileImageUrl)
                    }
                    
                    self?.usernameLabel.text = user.profile.username
                }
            }).disposed(by: disposeBag)
    }
}


extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseId, for: indexPath) as! MyPageTableViewCell
        cell.setCell(listTitles[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let chatVC = ChatVC(userVM: self.userVM)
            navigationController?.pushViewController(chatVC, animated: true)
            break
        case 1:
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .destructive))
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                UserDefaults.standard.removeToken()
            })
            
            self.present(alert, animated: true, completion: nil)
            break
        case 2:
            let unregisterVC = UnregisterVC(userVM: userVM)
            self.navigationController?.pushViewController(unregisterVC, animated: true)
            break
        default:
            break
        }
    }
    
    
    @objc private func handleTapEditButton() {
        let editProfileVC = EditProfileVC(userVM: userVM)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
