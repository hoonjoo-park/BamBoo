import UIKit
import SnapKit

class MyPageVC: UIViewController {
    private let tableView = UITableView(frame: .zero)
    private let headerView = UIView()
    private let listTitles = ["채팅", "로그아웃", "회원 탈퇴", "버전 정보"]
    let userVM = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BambooColors.black
        navigationController?.isNavigationBarHidden = true
        
        configureSubViews()
        configureHeaderView()
        configureTableView()
    }
    
    
    private func configureSubViews() {
        view.addSubview(tableView)
//        [headerView, tableView].forEach {
//            view.addSubview($0)
//        }
    }
    
    
    private func configureHeaderView() {
        let profileImage = UIImageView(image: UIImage(named: "panda"))
        let usernameLabel = BambooLabel(fontSize: 18, weight: .semibold, color: BambooColors.white)
        let profileEditButton = UIButton()
        let editIcon = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        let editLabel = BambooLabel(fontSize: 14, weight: .medium, color: BambooColors.gray)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 70)
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
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(usernameLabel.snp.centerY)
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
            break
        case 1:
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                UserDefaults.standard.removeToken()
                
                let onboardingVC = OnboardingVC()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = onboardingVC
                    window.makeKeyAndVisible()
                    
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            })
            alert.addAction(UIAlertAction(title: "취소", style: .destructive))
            
            self.present(alert, animated: true, completion: nil)
            break
        case 2:
            break
        default:
            break
        }
    }
}
