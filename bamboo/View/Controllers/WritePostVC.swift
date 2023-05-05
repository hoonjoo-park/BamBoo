import UIKit
import SnapKit

class WritePostVC: UIViewController {
    let locationButton = PressableButton()
    let locationButtonPlaceHolder = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let arrowDownIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
    let titleInput = UITextField()
    let contentInput = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = BambooColors.white
        navigationController?.navigationBar.backgroundColor = BambooColors.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: BambooColors.white]
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeborderBottom(superView: locationButton, height: 1, color: BambooColors.darkGray.cgColor)
    }
    
    
    private func configureViewController() {
        let backButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(closeButtonTapped))
        let postButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(postButtonTapped))
        
        view.backgroundColor = BambooColors.black
        postButton.tintColor = BambooColors.green
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = postButton
    }
    
    
    private func configureUI() {
        titleInput.placeholder = "제목을 입력해 주세요"
        contentInput.placeholder = "본문 내용을 입력해 주세요"
        locationButtonPlaceHolder.text = "위치를 선택해 주세요"
        arrowDownIcon.tintColor = BambooColors.gray
        
        
        [locationButton, titleInput, contentInput].forEach {
            view.addSubview($0)
        }
        
        [locationButtonPlaceHolder, arrowDownIcon].forEach {
            locationButton.addSubview($0)
        }
        
        locationButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(55)
        }
        
        locationButtonPlaceHolder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }
        
        arrowDownIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
        
        titleInput.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        contentInput.snp.makeConstraints { make in
            make.top.equalTo(titleInput.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
    }
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func postButtonTapped() {
        print("post button tapped!")
    }
}
