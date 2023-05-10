import UIKit

class ListModalTableView: UITableView {    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureTableView() {
        backgroundColor = BambooColors.lightNavy
        layer.cornerRadius = 8
    }
}
