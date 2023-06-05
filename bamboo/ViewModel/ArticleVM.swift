import Foundation
import RxSwift
import RxCocoa

class ArticleVM {
    let disposeBag = DisposeBag()
    
    private let articleListSubject = BehaviorSubject<[ArticleList?]>(value: [])
    var articleLists: Observable<[ArticleList?]> {
        return articleListSubject.asObservable()
    }
    private let articleSubject = BehaviorSubject<Article?>(value: nil)
    var article: Observable<Article?> {
        return articleSubject.asObservable()
    }
    
    
    func fetchArticleList(cityId: Int, districtId: Int) {
        NetworkManager.shared.fetchArticleList(cityId: cityId, districtId: districtId)
            .subscribe(onNext: { [weak self] articleLists in
                self?.articleListSubject.onNext(articleLists)
            }).disposed(by: disposeBag)
    }
    
    
    func getSelectedArticleList(index: Int) -> ArticleList? {
        do {
            guard let selectedArticleList = try articleListSubject.value()[index] else { return nil }
            
            return selectedArticleList
        } catch {
            print("getSelectedArticleList error: \(error)")
            return nil
        }
    }
    
    
    func fetchArticle(articleId: Int) {
        NetworkManager.shared.fetchArticle(articleId: articleId)
            .subscribe(onNext: { [weak self] article in
                self?.articleSubject.onNext(article)
            }).disposed(by: disposeBag)
    }
    
    
    func addLike() {
        do {
            guard let currentArticle = try articleSubject.value() else { return }
            
            let currentId = currentArticle.id
            
        } catch {
            print("addLike error: \(error)")
            return
        }
    }
    
    
    func getArticle() -> Article? {
        do {
            return try articleSubject.value()
        } catch {
            print("getArticle error: \(error)")
            return nil
        }
    }
}
