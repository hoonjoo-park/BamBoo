import UIKit

class LocationVC: BottomSheetVC {
    var fromVC: String!
    
    let cityButton = LocationSelectButton(text: "도시 선택")
    let districtButton = LocationSelectButton(text: "시/군/구 선택")
    
    lazy var saveLocationButton: LabelButton = {
        let button = LabelButton(fontSize: 14, weight: .semibold, color: BambooColors.white)
        button.buttonLabel.text = "위치 선택 완료"
        button.layer.cornerRadius = 8
        button.backgroundColor = BambooColors.green
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubViews()
    }
    
    
    init(fromVC: String!) {
        super.init(title: "위치 설정", height: CGFloat(500))
        self.fromVC = fromVC
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureSubViews() {
        [cityButton, districtButton, saveLocationButton].forEach {
            containerView.addSubview($0)
        }
        
        saveLocationButton.addTarget(self, action: #selector(handleTapSaveLocationButton), for: .touchUpInside)
        saveLocationButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(35)
            make.height.equalTo(45)
            make.bottom.equalTo(containerView.snp.bottom).inset(35)
        }
        
        cityButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(35)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.height.equalTo(45)
        }
        
        districtButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(35)
            make.top.equalTo(cityButton.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
    }
    
    
    @objc private func handleTapSaveLocationButton() {
        // TODO: 선택한 위치 저장 및 ViewModel 업데이트 하는 로직 구현 필요
        print("Save Location Button Tapped!")
    }
}
