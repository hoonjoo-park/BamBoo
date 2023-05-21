import UIKit
import SnapKit

protocol HomeHeaderViewDelegate: AnyObject {
    func openLocationBottomSheet()
}

class HomeHeaderView: UIView {
    var delegate: HomeHeaderViewDelegate!
    
    let appLogoImageView = UIImageView(image: UIImage(named: "bamboo-logo-horizontal"))
    let locationButton = PressableButton(frame: .zero)
    let locationButtonContainer = UIView()
    let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    let loacationLabel = BambooLabel(fontSize: 12, weight: .medium, color: BambooColors.white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        [appLogoImageView, locationButton].forEach { addSubview($0) }
        locationButton.addSubview(locationButtonContainer)
        [locationIcon, loacationLabel].forEach { locationButtonContainer.addSubview($0) }
        
        locationButton.layer.cornerRadius = 8
        locationButton.layer.borderWidth = 1
        locationButton.layer.borderColor = BambooColors.green.cgColor
        locationIcon.tintColor = BambooColors.green
        loacationLabel.text = "전체"
        
        appLogoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        locationButton.addTarget(self, action: #selector(handleTapLocationButton), for: .touchUpInside)
        locationButtonContainer.isUserInteractionEnabled = false
        
        locationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(30)
        }
        
        locationButtonContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        locationIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        loacationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(locationIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    
    @objc private func handleTapLocationButton() {
        delegate.openLocationBottomSheet()
    }
}
