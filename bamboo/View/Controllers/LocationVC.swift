import UIKit
import RxSwift
import RxCocoa

protocol LocationVCDelegate: AnyObject {
    func saveSelectedLocation(cityName: String, districtName: String)
}

class LocationVC: BottomSheetVC {
    var fromVC: String!
    var delegate: LocationVCDelegate?
    
    var selectedCityId: Int?
    var selectedDistrictId: Int?
    
    let disposeBag = DisposeBag()
    let locationVM = LocationVM.shared
    
    let cityButton = LocationSelectButton(text: "도시 선택")
    let districtButton = LocationSelectButton(text: "시/군/구 선택")
    let cityTableView = ListModalTableView(frame: .zero, style: .plain)
    let districtTableView = ListModalTableView(frame: .zero, style: .plain)
    
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
        setDataBinding()
    }
    
    
    override func handleTapBackdrop() {
        super.handleTapBackdrop()
        
        locationVM.clearSelectedArticleLocation()
    }
    
    
    init(fromVC: String!) {
        super.init(title: "위치 설정", height: CGFloat(500))
        self.fromVC = fromVC
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureSubViews() {
        [cityButton, districtButton, saveLocationButton, cityTableView, districtTableView].forEach {
            containerView.addSubview($0)
        }
        
        if let currentCityName = locationVM.selectedArticleLocation.value?.cityName {
            cityButton.placeholder.text = currentCityName
        }
        
        if let currentCityId = locationVM.selectedFilterLocation.value?.cityId {
            selectedCityId = currentCityId
        }
        
        if let currentDistrictName = locationVM.selectedArticleLocation.value?.districtName {
            districtButton.placeholder.text = currentDistrictName
        }
        
        if let currentDistrictId = locationVM.selectedFilterLocation.value?.districtId {
            selectedDistrictId = currentDistrictId
        }
        
        cityTableView.isHidden = true
        cityTableView.alpha = 0.0
        districtTableView.isHidden = true
        districtTableView.alpha = 0.0
        
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
        
        cityTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalTo(cityButton.snp.bottom).offset(5)
            make.height.equalTo(160)
        }
        
        districtTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalTo(districtButton.snp.bottom).offset(5)
            make.height.equalTo(160)
        }
    }
    
    
    private func setDataBinding() {
        cityTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "city-cell")
        districtTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "district-cell")
        
        LocationVM.shared.selectedArticleLocation
            .map { $0 != nil }
            .bind(to: districtButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        LocationVM.shared.selectedArticleLocation
            .map { $0?.districtId != nil }
            .bind(to: saveLocationButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        LocationVM.shared.locations
            .bind(to: cityTableView.rx.items(cellIdentifier: "city-cell", cellType: LocationTableViewCell.self)) { (row, location, cell) in
                cell.setCell(title: location.name)
            }.disposed(by: disposeBag)
        
        LocationVM.shared.districtsBySelectedCity
            .bind(to: districtTableView.rx.items(cellIdentifier: "district-cell", cellType: LocationTableViewCell.self)) { (row, district, cell) in
                cell.setCell(title: district.name)
            }.disposed(by: disposeBag)
        
        cityTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let selectedCity = self.locationVM.locations.value[indexPath.row]
                
                self.selectedCityId = selectedCity.id
                self.cityButton.placeholder.text = selectedCity.name
                self.districtButton.placeholder.text = "시/군/구 선택"
                self.locationVM
                    .updateSelectedArticleLocation(location: SelectedLocation(cityId: selectedCity.id,
                                                                              cityName: selectedCity.name,
                                                                              districtId: nil,
                                                                              districtName: nil))
                self.locationVM.updateDistrictsBySelectedCity(districts: selectedCity.districts)
                self.handleTapCityButton()
            }).disposed(by: disposeBag)
        
        
        districtTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let selectedDistrict = self?.locationVM.districtsBySelectedCity.value[indexPath.row],
                      let currentLocation = self?.locationVM.selectedArticleLocation.value else { return }
                
                self?.selectedDistrictId = selectedDistrict.id
                self?.districtButton.placeholder.text = selectedDistrict.name
                self?.locationVM
                    .updateSelectedArticleLocation(location: SelectedLocation(cityId: selectedDistrict.cityId,
                                                                              cityName: currentLocation.cityName,
                                                                              districtId: selectedDistrict.id,
                                                                              districtName: selectedDistrict.name))
                self?.handleTapDistrictButton()
            }).disposed(by: disposeBag)
    }
    
    
    @objc private func handleTapCityButton() {
        if !districtTableView.isHidden {
            handleTapDistrictButton()
        }
        
        cityButton.isTapped = !cityButton.isTapped
        cityTableView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.cityTableView.alpha = self.cityTableView.alpha == 0.0 ? 1.0 : 0.0
        } completion: { (finished) in
            if finished {
                self.cityTableView.isHidden = self.cityTableView.alpha == 0.0
            }
        }
    }
    
    
    @objc private func handleTapDistrictButton() {
        if !cityTableView.isHidden {
            handleTapCityButton()
        }
        
        districtButton.isTapped = !districtButton.isTapped
        districtTableView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.districtTableView.alpha = self.districtTableView.alpha == 0.0 ? 1.0 : 0.0
        } completion: { (finished) in
            if finished {
                self.districtTableView.isHidden = self.districtTableView.alpha == 0.0
            }
        }
    }
    
    
    @objc private func handleTapSaveLocationButton() {
        guard let delegate = delegate,
              let cityName = cityButton.placeholder.text,
              let cityId = selectedCityId,
              let districtId = selectedDistrictId,
              let districtName = districtButton.placeholder.text else { return }
        
        delegate.saveSelectedLocation(cityName: cityName, districtName: districtName)
        locationVM.updateSelectedLocation(location: SelectedLocation(cityId: cityId,
                                                                     cityName: cityName,
                                                                     districtId: districtId,
                                                                     districtName: districtName))
        dismissBottomSheet()
    }
}
