import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

struct OAuthResponse: Codable {
    let token: String
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
    
    
    func postArticle(locationId: Int, title: String, content: String , completion: @escaping (Article?) -> Void) {
        let urlString = "\(baseUrl)/post"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let params: [String: String] = [
            "locationId": "\(locationId)",
            "title" : title,
            "content" : content,
        ]
        
        AF.request(urlString, method: .post, parameters: params, headers: headers)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success(let value):
                    if let data = value {
                        do {
                            let decodedData = try? self?.decoder.decode(Article.self, from: data)
                            completion(decodedData)
                        }
                    }
                    break
                case .failure(let error):
                    print("Add Post Error:", error.localizedDescription)
                    break
                }
            }
        
    }
}
