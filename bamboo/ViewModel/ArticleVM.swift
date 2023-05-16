import Foundation
import RxSwift
import RxCocoa

class ArticleVM {
    let disposeBag = DisposeBag()
    
    private let articlesSubject = BehaviorSubject<[Article?]>(value: [])
    var articles: Observable<[Article?]> {
        return articlesSubject.asObservable()
    }
    
    func updateArticles(_ articles: [Article]) {
        articlesSubject.onNext(articles)
    }
    
    func fetchArticleList(cityId: Int, districtId: Int) {
        NetworkManager.shared.fetchArticleList(cityId: cityId, districtId: districtId)
            .subscribe(onNext: { [weak self] articleLists in
                print(articleLists)
            }).disposed(by: disposeBag)
    }
}
