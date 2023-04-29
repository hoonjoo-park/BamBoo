import Foundation
import Alamofire
import RxAlamofire

struct OAuthResponse: Codable {
    let token: String
}

func postOAuth(_ accessToken: String, provider: String, completion: @escaping (String?) -> Void) {
    let params: [String: String] = ["accessToken": accessToken]
    let urlString = "http://localhost:3000/auth/\(provider)"
    
    AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
        .validate()
        .response { response in
            switch response.result {
            case .success(let value):
                if let data = value {
                    let decoder = JSONDecoder()
                    do {
                        let oauthResponse = try decoder.decode(OAuthResponse.self, from: data)
                        completion(oauthResponse.token)
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
