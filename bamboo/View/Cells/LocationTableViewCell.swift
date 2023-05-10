import UIKit
import SnapKit

class LocationTableViewCell: PressableTableViewCell {
    let locationVM = LocationVM.shared
    let titleLabel = BambooLabel(fontSize: 12, weight: .semibold, color: BambooColors.white)
    let locationPinIcon = UIImageView(image: UIImage(named: "location-pin"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCell(title: String) {
        titleLabel.text = title
    }
    
    
    func configureUI() {
        let padding: CGFloat = 20
        
        backgroundColor = BambooColors.lightNavy
        
        [locationPinIcon, titleLabel].forEach {
            addSubview($0)
        }
        
        locationPinIcon.tintColor = BambooColors.white
        locationPinIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(padding)
            make.width.height.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(locationPinIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(padding)
        }
    }

}
