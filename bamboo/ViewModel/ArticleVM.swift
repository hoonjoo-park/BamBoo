import Foundation
import RxSwift
import RxCocoa

class ArticleVM {
    let disposeBag = DisposeBag()
    
    private let articleListSubject = BehaviorSubject<[ArticleList?]>(value: [])
    var articleLists: Observable<[ArticleList?]> {
        return articleListSubject.asObservable()
    }
    
    func fetchArticleList(cityId: Int, districtId: Int) {
        NetworkManager.shared.fetchArticleList(cityId: cityId, districtId: districtId)
            .subscribe(onNext: { [weak self] articleLists in
                self?.articleListSubject.onNext(articleLists)
            }).disposed(by: disposeBag)
    }
}
