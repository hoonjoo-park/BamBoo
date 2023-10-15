import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

struct OAuthResponse: Codable {
    let token: String
}

enum BambooError: Error {
    case dataNotFound
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "http://localhost:3000"
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func postOAuth(_ accessToken: String, provider: String, completion: @escaping (String?) -> Void) {
        let params: [String: String] = ["accessToken": accessToken]
        let urlString = "\(baseUrl)/auth/\(provider)"
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success(let value):
                    if let data = value {
                        do {
                            if let oauthResponse = try self?.decoder.decode(OAuthResponse.self, from: data) {
                                completion(oauthResponse.token)
                            }
                        } catch {
                            print("OAuth Error: Decoding failed: \(error.localizedDescription)")
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("OAuth Error:", error.localizedDescription)
                    completion(nil)
                }
            }
    }
    
    func fetchUser() -> Observable<User> {
        let urlString = "\(baseUrl)/user/me"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else {
            return Observable.error(NSError(domain: "No token found", code: 401, userInfo: nil))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        return RxAlamofire.requestJSON(.get, urlString, headers: headers)
            .retry(3)
            .map { (response, json) -> User in
                if 200..<300 ~= response.statusCode, let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    let user = try self.decoder.decode(User.self, from: jsonData)
                    return user
                } else {
                    throw NSError(domain: "Failed to fetch user", code: response.statusCode, userInfo: nil)
                }
            }
    }
    
    
    func putUser(profileImage: Data, username: String, completion: @escaping (UserProfile?) -> Void) {
        let urlString = "\(baseUrl)/user/me"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(profileImage, withName: "profileImage", fileName: "profile-image.jpg", mimeType: "image/*")
            if let data = username.data(using: .utf8) {
                multipartFormData.append(data, withName: "username")
            }
        }, to: urlString, method: .put, headers: headers)
        .response { [weak self] response in
            switch response.result {
            case .success(let value):
                if let data = value {
                    do {
                        if let profile = try self?.decoder.decode(UserProfile.self, from: data) {
                            completion(profile)
                        }
                    } catch {
                        print("Put User Error: Decoding failed: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            case .failure(let error):
                print("Put User Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    
    func deleteUser(completion: @escaping () -> Void) {
        let urlString = "\(baseUrl)/user/me"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        _ = AF.request(urlString, method: .delete, headers: headers).response { response in
            switch response.result {
            case .success(_):
                completion()
                break
            case .failure(let error):
                print("Delete User Error: \(error)")
                break
            }
        }
    }
    
    
    func postArticle(cityId: Int, districtId: Int, title: String, content: String , completion: @escaping (ArticleList?) -> Void) {
        let urlString = "\(baseUrl)/article"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let params: [String: Any] = [
            "cityId": cityId,
            "districtId": districtId,
            "title" : title,
            "content" : content,
        ]
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success(let value):
                    if let data = value {
                        do {
                            let decodedData = try? self?.decoder.decode(ArticleList.self, from: data)
                            completion(decodedData)
                        }
                    }
                    break
                case .failure(let error):
                    print("Post Article Error:", error.localizedDescription)
                    break
                }
            }
    }
    
    
    func fetchLocations() -> Observable<[City]> {
        let urlString = "\(baseUrl)/location"
        
        return RxAlamofire.requestData(.get, urlString)
            .flatMap { [weak self] (response, data) -> Observable<[City]> in
                if 200 ..< 300 ~= response.statusCode {
                    do {
                        if let cities = try self?.decoder.decode([City].self, from: data) {
                            return Observable.just(cities)
                        } else {
                            return Observable.error(NSError(domain: "Fetch Locations Error", code: -1))
                        }
                    } catch {
                        return Observable.error(error)
                    }
                } else {
                    return Observable.error(NSError(domain: "Fetch Locations Error", code: response.statusCode))
                }
            }
    }
    
    
    func fetchArticleList(cityId: Int, districtId: Int) -> Observable<[ArticleList]> {
        let urlString = "\(baseUrl)/article"
        var params = [
            "cityId": cityId
        ]
        
        if districtId >= 0 {
            params["districtId"] = districtId
        }
        
        return RxAlamofire
            .request(.get, urlString, parameters: params)
            .validate()
            .responseJSON()
            .map { [unowned self] response -> [ArticleList] in
                guard let data = response.data else { throw BambooError.dataNotFound }
                return try self.decoder.decode([ArticleList].self, from: data)
            }
    }
    
    func fetchArticle(articleId: Int) -> Observable<Article> {
        let urlString = "\(baseUrl)/article/\(articleId)"
        
        return RxAlamofire
            .request(.get, urlString)
            .validate()
            .responseJSON()
            .map { [unowned self] response -> Article in
                guard let data = response.data else { throw BambooError.dataNotFound }
                return try self.decoder.decode(Article.self, from: data)
            }
    }
    
    
    func postArticleLike(articleId: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/article/like/\(articleId)"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlString, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .failure(let error):
                    print("Post Article Like Error:", error.localizedDescription)
                    completion(false)
                default:
                    completion(true)
                }
            }
    }
    
    
    func deleteArticleLike(articleId: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/article/like/\(articleId)"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlString, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .failure(let error):
                    print("Delete Article Like Error:", error.localizedDescription)
                    completion(false)
                default:
                    completion(true)
                }
            }
    }
    
    
    func postComment(articleId: Int, content: String, parentCommentId: Int?, completion: @escaping () -> Void) {
        let urlString = "\(baseUrl)/comment/\(articleId)"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        var params = [
            "content": content,
        ]
        
        if let parentCommentId = parentCommentId {
            params["parentCommentId"] = String(parentCommentId)
        }
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .failure(let error):
                    print("Post Comment Error:", error.localizedDescription)
                    break
                default:
                    completion()
                    break
                }
            }
    }
    
    
    func deleteComment(commentId: Int, completion: @escaping () -> Void) {
        let urlString = "\(baseUrl)/comment/\(commentId)"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlString, method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .failure(let error):
                    print("Delete Comment Error:", error.localizedDescription)
                    break
                default:
                    completion()
                    break
                }
            }
    }
}
