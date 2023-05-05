import UIKit
import SnapKit

class WritePostVC: UIViewController {
    let locationButton = PressableButton()
    let locationButtonPlaceHolder = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let arrowDownIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
    let titleInput = UITextField()
    let contentInput = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        configureContentInput()
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
        
        contentInput.delegate = self
        view.backgroundColor = BambooColors.black
        backButton.tintColor = BambooColors.gray
        postButton.tintColor = BambooColors.green
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = postButton
    }
    
    
    private func configureUI() {
        locationButtonPlaceHolder.text = "위치를 선택해 주세요"
        arrowDownIcon.tintColor = BambooColors.gray
        titleInput.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentInput.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleInput.textColor = BambooColors.white
        titleInput.attributedPlaceholder = NSAttributedString(string: "제목을 입력해 주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: BambooColors.gray])
        contentInput.textColor = BambooColors.white
        contentInput.backgroundColor = .clear
        contentInput.isScrollEnabled = true
        contentInput.showsVerticalScrollIndicator = true
        
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
            make.height.equalTo(20)
        }
        
        contentInput.snp.makeConstraints { make in
            make.top.equalTo(titleInput.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    
    private func configureContentInput() {
        contentInput.text = "본문 내용을 입력해 주세요"
        contentInput.textColor = BambooColors.gray
    }
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func postButtonTapped() {
        print("post button tapped!")
    }
}


extension WritePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "본문 내용을 입력해 주세요" {
            textView.text = ""
            textView.textColor = BambooColors.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "본문 내용을 입력해 주세요"
            textView.textColor = BambooColors.gray
        }
    }
}
