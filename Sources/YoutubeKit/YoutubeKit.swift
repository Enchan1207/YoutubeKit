//
//  YoutubeKit.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public class YoutubeKit {
    public typealias SuccessCallback<T> = (_ response: T) -> Void
    public typealias FailCallback = (_ error: Error) -> Void
    
    // credentials
    public let apiCredential: APICredential
    public var accessCredential: AccessCredential?
    
    // Quota cost
    internal (set) public static var quotaCost: UInt = 0
    
    /// Generate Instance.
    /// - Parameters:
    ///    - accessCredential: Credentials of Youtube Data API
    ///    - clientID: Youtube Data API client ID
    public init(apiCredential: APICredential, accessCredential: AccessCredential?){
        self.apiCredential = apiCredential
        self.accessCredential = accessCredential
    }
    
    /// refresh access token.
    ///  - Parameters:
    ///    - success: callback when token refreshed.
    ///    - failure: callback when refresh failed.
    func updateToken(success: @escaping SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping FailCallback){
        
        let updateURL = URL(string: "https://accounts.google.com/o/oauth2/token")!
        guard let refreshToken = self.accessCredential?.refreshToken else {return}
        let queryItems = [
            "client_id": self.apiCredential.clientID,
            "client_secret": self.apiCredential.clientSecret,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ]
        let config = RequestConfig(url: updateURL, method: .POST, queryItems: queryItems)
        
        URLSession.shared.dataTask(with: config.createURLRequest()) { (data, response, error) in
            // エラー!
            if let error = error {
                failure(error)
                return
            }
            
            // レスポンスボディがある場合は取得
            let responseBody: String
            if let data = data{
                responseBody = String(data: data, encoding: .utf8)!
            }else{
                responseBody = ""
            }
            
            // リクエストに失敗した場合は、networkErrorにステータスコードとレスポンスを載せて返す
            let response = response as! HTTPURLResponse
            if([.ClientErrors, .ServerErrors].contains(response.typeOfStatusCode())){
                failure(YoutubeKit.APIError.networkError(response.statusCode, responseBody))
                return
            }
            
            // レスポンスをjsonパースし、credentialを再生成
            struct Response: Codable{
                let access_token: String
                let expires_in: Int
                let refresh_token: String?
                let scope: String
                let token_type: String
            }
            guard let responseJson = try? JSONDecoder().decode(Response.self, from: data!) else{
                failure(YoutubeKit.AuthError.invalidResponse)
                return
            }
            self.accessCredential?.accessToken = responseJson.access_token
            if #available(iOS 13.0, *) {
                self.accessCredential?.expires = Date().addingTimeInterval(TimeInterval(responseJson.expires_in))
            } else {
                self.accessCredential?.expires = Date().addingTimeInterval(TimeInterval(responseJson.expires_in))
            }
            success(self.accessCredential!)
        }.resume()
    }
}
