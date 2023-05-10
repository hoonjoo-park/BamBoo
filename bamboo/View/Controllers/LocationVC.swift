import UIKit
import RxSwift
import RxCocoa

class LocationVC: BottomSheetVC {
    var fromVC: String!
    let disposeBag = DisposeBag()
    let locationVM = LocationVM.shared
    
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
        
        configureGestureHandler()
        configureSubViews()
        setDataBinding()
    }
    
    
    init(fromVC: String!) {
        super.init(title: "위치 설정", height: CGFloat(500))
        self.fromVC = fromVC
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureGestureHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapContainerView))
        containerView.addGestureRecognizer(tapGestureRecognizer)
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
        
        cityButton.addTarget(self, action: #selector(handleTapCityButton), for: .touchUpInside)
        cityButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(35)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.height.equalTo(45)
        }
        
        districtButton.addTarget(self, action: #selector(handleTapDistrictButton), for: .touchUpInside)
        districtButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView).inset(35)
            make.top.equalTo(cityButton.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
    }
    
    
    private func setDataBinding() {
        LocationVM.shared.selectedArticleLocation
            .map { $0 != nil }
            .bind(to: districtButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    @objc private func handleTapContainerView() {
        cityButton.isTapped = false
        districtButton.isTapped = false
    }
    
    
    @objc private func handleTapCityButton() {
        cityButton.isTapped = !cityButton.isTapped
    }
    
    
    @objc private func handleTapDistrictButton() {
        districtButton.isTapped = !districtButton.isTapped
    }
    
    
    @objc private func handleTapSaveLocationButton() {
        print("Save Location Button Tapped!")
    }
}
