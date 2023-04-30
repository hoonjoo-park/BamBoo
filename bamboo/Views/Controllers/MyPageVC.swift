import UIKit
import SnapKit

class MyPageVC: UIViewController {
    private let tableView = UITableView(frame: .zero)
    private let headerView = UIView()
    private let listTitles = ["채팅", "로그아웃", "회원 탈퇴", "버전 정보"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BambooColors.black
        
        configureSubViews()
        configureHeaderView()
        configureTableView()
    }
    
    
    private func configureSubViews() {
        [headerView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    
    private func configureHeaderView() {
        headerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    
    private func configureTableView() {
        tableView.backgroundColor = BambooColors.black
        tableView.separatorColor = BambooColors.gray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseId)
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
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
}
