//
//  APIRequest.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension YoutubeKit{
    
    /// send api request using credential.
    ///  - Parameters:
    ///     - config: request configuration
    ///     - success: success callback
    ///     - failure: fairule callback
    func sendRequest(config _config: RequestConfig,
                     success: @escaping SuccessCallback<String>, failure: @escaping FailCallback){
        
        var config = _config
        
        // アクセストークンをヘッダに挿入
        if let accessCredential = self.accessCredential {
            config.requestHeader["Authorization"] = "Bearer \(accessCredential.accessToken)"
        }
        
        // APIキー自動挿入
        let apiCredential = self.apiCredential
        config.queryItems["key"] = apiCredential.APIKey
        config.queryItems["client_id"] = apiCredential.clientID
        config.queryItems["client_secret"] = apiCredential.clientSecret
        
        // Sessionに投げる
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
            
            success(responseBody)
        }.resume()
    }
    
    /// send api request using credential (auto-credential-update).
    ///  - Parameters:
    ///     - config: request configuration
    ///     - success: success callback
    ///     - failure: fairule callback
    func sendRequestWithAutoUpdate(config _config: RequestConfig,
                                   success: @escaping SuccessCallback<String>, failure: @escaping FailCallback){
        // ログインしていなければ飛ばす
        guard let accessCredential = self.accessCredential else{
            failure(YoutubeKit.AuthError.loginRequired)
            return
        }
        
        // 期限切れならトークンを更新し
        if accessCredential.isOutdated(){
            self.updateToken(success: { (credential) in
                // 更新に成功したらrequestを飛ばす
                self.sendRequest(config: _config, success: success, failure: failure)
            }, failure: failure)
        }else{
            self.sendRequest(config: _config, success: success, failure: failure)
        }
    }
    
}
