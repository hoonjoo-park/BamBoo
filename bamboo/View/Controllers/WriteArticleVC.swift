import UIKit
import SnapKit

class WriteArticleVC: UIViewController {
    let locationButton = PressableButton()
    let locationButtonPlaceHolder = BambooLabel(fontSize: 16, weight: .semibold, color: BambooColors.white)
    let arrowDownIcon = UIImageView(image: UIImage(systemName: "chevron.down"))
    let titleInput = UITextField()
    let contentInput = UITextView()
    let titleInputPlaceHolder = "제목을 입력해 주세요"
    let contentInputPlaceholderText = "본문 내용을 입력해 주세요"
    
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
        titleInput.attributedPlaceholder = NSAttributedString(string: titleInputPlaceHolder,
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
        
        locationButton.addTarget(self, action: #selector(handleTapLoactionButton), for: .touchUpInside)
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
        contentInput.text = contentInputPlaceholderText
        contentInput.textColor = BambooColors.gray
    }
    
    
    @objc func closeButtonTapped() {
        let isTitleEmpty = titleInput.text?.isEmpty ?? true || titleInput.text == titleInputPlaceHolder
        let isContentEmpty = contentInput.text.isEmpty || contentInput.text == contentInputPlaceholderText
        
        if isTitleEmpty && isContentEmpty {
            dismiss(animated: true, completion: nil)
        } else {
            let confirm = UIAlertController(title: "입력 내용이 사라집니다", message: "정말 페이지에서 나가시겠습니까?", preferredStyle: .alert)
            
            confirm.addAction(UIAlertAction(title: "나가기", style: .destructive) { [weak self] action in
                self?.dismiss(animated: true, completion: nil)
            })
            confirm.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            present(confirm, animated: true, completion: nil)
        }
    }
    
    
    @objc func handleTapLoactionButton() {
        let locationVC = LocationVC(fromVC: "WriteArticleVC")
        locationVC.modalPresentationStyle = .overCurrentContext
        locationVC.delegate = self
        
        present(locationVC, animated: false)
    }
    
    
    @objc func postButtonTapped() {
        let cityId = 1
        let districtId = 1
        
        guard let title = titleInput.text, let content = contentInput.text else {
            // TODO: 토스트 메시지로 위치, 제목, 본문 내용 등의 내용 입력이 필수임을 알리는 로직 구현 필요
            return
        }
        
        NetworkManager.shared.postArticle(cityId: cityId, districtId: districtId, title: title, content: content) { [weak self] article in
            // TODO: ArticleVM 업데이트 로직 구현 필요
        }
    }
}


extension WriteArticleVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentInputPlaceholderText {
            textView.text = ""
            textView.textColor = BambooColors.white
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentInputPlaceholderText
            textView.textColor = BambooColors.gray
        }
    }
}

extension WriteArticleVC: LocationVCDelegate {
    func saveSelectedLocation(cityName: String, districtName: String) {
        locationButtonPlaceHolder.text = "\(cityName), \(districtName)"
    }
}
