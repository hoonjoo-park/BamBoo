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
                            print("OAuth Error: Decoding failed: \(error)")
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("OAuth Error:", error)
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
    
    
    func putUser(profileImage: Data, username: String) {
        let urlString = "\(baseUrl)/user/me"
        let token = UserDefaults.standard.getToken()
        
        guard let token = token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(profileImage, withName: "profileImage", fileName: "image.jpg", mimeType: "image/*")
            if let data = username.data(using: .utf8) {
                multipartFormData.append(data, withName: "username")
            }
        }, to: urlString, method: .put, headers: headers)
        .response { response in
            switch response.result {
            case .success(let value):
                print("Success: \(value)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func deleteUser(userId: Int) {
        print(userId)
    }
}
