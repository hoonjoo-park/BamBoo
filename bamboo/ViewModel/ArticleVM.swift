import Foundation
import RxSwift
import RxCocoa

class ArticleVM {
    private let articlesSubject = BehaviorSubject<[Article?]>(value: [])
    var articles: Observable<[Article?]> {
        return articlesSubject.asObservable()
    }
    
    func updateArticles(_ articles: [Article]) {
        articlesSubject.onNext(articles)
    }
}
