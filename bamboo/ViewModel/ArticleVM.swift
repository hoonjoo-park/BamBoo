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
    
    
    func addLike(userId: Int) {
        do {
            guard let currentArticle = try articleSubject.value() else { return }
            
            let currentId = currentArticle.id
            
            NetworkManager.shared.postArticleLike(articleId: currentId) { [weak self] isSuccess in
                if isSuccess {
                    var newArticle = currentArticle
                    newArticle.likes.append(ArticleLike(userId: userId, articleId: currentId))
                    self?.articleSubject.onNext(newArticle)
                    self?.updateArticleListLike(currentId, "add")
                }
            }
        } catch {
            print("addLike error: \(error)")
        }
    }
    
    
    func deleteLike(userId: Int) {
        do {
            guard let currentArticle = try articleSubject.value() else { return }
            
            let currentId = currentArticle.id
            
            NetworkManager.shared.deleteArticleLike(articleId: currentId) { [weak self] isSuccess in
                if isSuccess {
                    var newArticle = currentArticle
                    newArticle.likes = newArticle.likes.filter { articleLike in
                        return articleLike.userId != userId
                    }
                    
                    self?.articleSubject.onNext(newArticle)
                    self?.updateArticleListLike(currentId, "delete")
                }
            }
        } catch {
            print("addLike error: \(error)")
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
    
    
    func checkIsArticleLiked(userId: Int) -> Bool {
        do {
            guard let currentArticle = try articleSubject.value() else { return false }
            
            let isLiked = currentArticle.likes.contains { articleLike in
                articleLike.userId == userId
            }
            
            return isLiked
        } catch {
            print("checkIsArticleLiked error: \(error)")
            return false
        }
    }
    
    
    func updateArticleListLike(_ currentId: Int, _ type: String) {
        do {
            let articleList = try articleListSubject.value()
            
            let newArticleList = articleList.map { list -> ArticleList? in
                guard var currentList = list else { return nil }
                
                if currentList.id == currentId {
                    if type == "add" {
                        currentList.likeCount += 1
                    } else {
                        currentList.likeCount -= 1
                    }
                }
                
                return currentList
            }
            
            articleListSubject.onNext(newArticleList)
        } catch {
            print("updateArticleListLike error: \(error)")
        }
    }
    
    
    func updateArticleListCommentCount(articleId: Int, type: String) {
        do {
            let articleList = try articleListSubject.value()
            
            let newArticleList = articleList.map { list -> ArticleList? in
                guard var currentList = list else { return nil }
                
                if currentList.id == articleId {
                    if type == "add" {
                        currentList.commentCount += 1
                    } else {
                        currentList.commentCount = max(0, currentList.commentCount - 1)
                    }
                }
                
                return currentList
            }
            
            articleListSubject.onNext(newArticleList)
        } catch {
            print("updateArticleListCommentCount error: \(error)")
        }
    }
}
