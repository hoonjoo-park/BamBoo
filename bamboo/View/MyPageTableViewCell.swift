import UIKit
import SnapKit

class MyPageTableViewCell: UITableViewCell {
    static let reuseId = "myPageCell"
    let titleLabel = BambooLabel(fontSize: 16, weight: .medium, color: BambooColors.white)
    var listIcon = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(_ title: String) {
        titleLabel.text = title
        
        switch title {
        case "채팅":
            listIcon.image = UIImage(systemName: "message")
            break
        case "로그아웃":
            listIcon.image = UIImage(systemName: "arrowshape.turn.up.right.circle")
            break
        case "회원 탈퇴":
            listIcon.image = UIImage(systemName: "person.crop.circle.badge.minus")
            break
        case "버전 정보":
            listIcon.image = UIImage(systemName: "info.circle")
            setVersionInfo()
            break
        default:
            break
        }
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 25
        
        backgroundColor = BambooColors.black
        listIcon.tintColor = BambooColors.white
        
        [listIcon, titleLabel].forEach {
            addSubview($0)
        }
        
        listIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(padding)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(listIcon.snp.trailing).offset(15)
        }
    }
    
    
    private func setVersionInfo() {
        let versionLabel = BambooLabel(fontSize: 16, weight: .regular, color: BambooColors.white)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        addSubview(versionLabel)
        versionLabel.text = version
        
        versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(25)
        }
    }
}
