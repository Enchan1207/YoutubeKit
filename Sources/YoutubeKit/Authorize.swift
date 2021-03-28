//
//  Authorize.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import UIKit
import Foundation

public extension YoutubeKit {
    
    /// Authorize user and generate token.
    ///  - Parameters:
    ///    - presentViewController: viewcontroller that shows authorization screen.
    ///    - scope: scopes that app requires from user
    ///    - success: callback when authorization succeeded.
    ///    - failure: callback when authorization failed.
    func authorize (presentViewController: UIViewController,
                    scope: [YoutubeKit.Scope],
                    success: @escaping SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping FailCallback){
        
        
        // 取得先BundleはSPMとそうでない場合とで異なる(らしい)
        // cf. https://developer.apple.com/documentation/swift_packages/bundling_resources_with_a_swift_package
        // cf. https://qiita.com/kazuhiro4949/items/0378e163fa00a79eb00a
        let bundle: Bundle
        #if SWIFT_PACKAGE
        bundle = Bundle.module
        #else
        bundle = Bundle(for: type(of: self))
        #endif
        
        // Storyboardから認証画面を生成
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: bundle)
        guard let navigationController = storyboard.instantiateInitialViewController() else{
            fatalError("Couldn't instantiate authorize view controller.")
        }
        
        guard let authViewController = navigationController.children.first as? AuthViewController else{
            fatalError("generated viewcontroller is not type of AuthViewController.")
        }
        
        // データを渡して
        authViewController.configure(apiCredential: self.apiCredential, scope: scope) { (credential) in
            self.accessCredential = credential
            success(credential)
        } failure: { (error) in
            failure(error)
        }
        
        // 表示
        presentViewController.present(navigationController, animated: true, completion: nil)
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
