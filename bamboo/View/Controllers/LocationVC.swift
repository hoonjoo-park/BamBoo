import UIKit

class LocationVC: BottomSheetVC {
    var fromVC: String!
    
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
        [saveLocationButton].forEach {
            containerView.addSubview($0)
        }
        
        saveLocationButton.addTarget(self, action: #selector(handleTapSaveLocationButton), for: .touchUpInside)
        saveLocationButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(25)
            make.height.equalTo(45)
            make.bottom.equalTo(containerView.snp.bottom).inset(35)
        }
    }
    
    
    @objc private func handleTapSaveLocationButton() {
        // TODO: 선택한 위치 저장 및 ViewModel 업데이트 하는 로직 구현 필요
        print("Save Location Button Tapped!")
    }
}
