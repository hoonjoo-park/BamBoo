import Foundation
import RxSwift
import RxCocoa

struct SelectedLocation {
    let cityId: Int
    let districtId: Int?
}

class LocationVM {
    static let shared = LocationVM()
    
    private let disposeBag = DisposeBag()
    
    private(set) var locations = BehaviorRelay<[City]>(value: [])
    private(set) var selectedFilterLocation = BehaviorRelay<SelectedLocation?>(value: nil)
    private(set) var selectedArticleLocation = BehaviorRelay<SelectedLocation?>(value: nil)
    private(set) var districtsBySelectedCity = BehaviorRelay<[District]>(value: [])
    
    
    private init() {}
    
    
    func fetchLocations() {
        NetworkManager.shared.fetchLocations()
            .subscribe(onNext: { [weak self] cities in
                self?.locations.accept(cities)
            })
            .disposed(by: disposeBag)
    }
    
    
    func updateSelectedLocation(location: SelectedLocation) {
        selectedFilterLocation.accept(location)
    }
    
    
    func updateSelectedArticleLocation(location: SelectedLocation) {
        selectedArticleLocation.accept(location)
    }
    
    
    func updateDistrictsBySelectedCity(districts: [District]) {
        let districtsIncludeAll = District(id: -1, cityId: districts[0].cityId, name: "전체")
        districtsBySelectedCity.accept([districtsIncludeAll] + districts)
    }
    
    
    func clearSelectedArticleLocation() {
        selectedArticleLocation.accept(nil)
    }
}
