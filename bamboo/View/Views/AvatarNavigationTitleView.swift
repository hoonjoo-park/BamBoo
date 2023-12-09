import UIKit
import SnapKit
import Kingfisher

class AvatarNavigationTitleView: UIView {
    var profileImage: String?
    
    let containerView = UIView()
    let titleLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.white)
    let profileImageView = UIImageView()
    
    init(profileImage: String?, title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        self.profileImage = profileImage
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        profileImageView.layer.cornerRadius = 12.5
        profileImageView.clipsToBounds = true
        addSubview(containerView)
        [titleLabel, profileImageView].forEach { containerView.addSubview($0) }
        
        if let profileImage = self.profileImage,
           let profileImageUrl = URL(string: profileImage) {
            self.profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "avatar")
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
}
