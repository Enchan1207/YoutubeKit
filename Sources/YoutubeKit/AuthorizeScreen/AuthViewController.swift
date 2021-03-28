//
//  AuthViewController.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import UIKit
import WebKit

public class AuthViewController: UIViewController {
    
    // credentials
    private var apiCredential: YoutubeKit.APICredential? = nil
    private var scope: [YoutubeKit.Scope] = []
    
    // callback
    private var successCallback: ((_ credential: YoutubeKit.AccessCredential) -> Void)?
    private var failureCallback: ((_ error: YoutubeKit.AuthError) -> Void)?
    
    // webview
    private var isLoaded: Bool = false
    private var estimatedProgressObservationToken: NSKeyValueObservation?
    private var navigationGoBackObservationToken: NSKeyValueObservation?
    private var navigationGoForwardObservationToken: NSKeyValueObservation?
    private var hostnameObservationToken: NSKeyValueObservation?
    
    // ui
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webProgressBar: UIProgressView!
    @IBOutlet weak var navigationBackButton: UIBarButtonItem!
    @IBOutlet weak var navigationForwardButton: UIBarButtonItem!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // webview初期化
        webView.customUserAgent = "Mozilla/5.0 (iPhone; iPhone like Mac OS X) AppleWebKit (KHTML, like Gecko) Safari"
        webView.navigationDelegate = self
        
        // observer設定
        
        // プログレスバー更新
        self.estimatedProgressObservationToken = webView.observe(\.estimatedProgress) { (webView, change) in
            let progress = webView.estimatedProgress
            self.webProgressBar.alpha = 1
            self.webProgressBar.setProgress(Float(progress), animated: true)
        }
        
        // Can we go back
        self.navigationGoBackObservationToken = webView.observe(\.canGoBack) { (object, change) in
            self.navigationBackButton.isEnabled = self.webView.canGoBack
        }
        
        // Can we go forward
        self.navigationGoForwardObservationToken = webView.observe(\.canGoForward) { (object, change) in
            self.navigationBackButton.isEnabled = self.webView.canGoForward
        }
        
        // ホスト名
        self.hostnameObservationToken = webView.observe(\.title) { (object, change) in
            self.title = self.webView.title
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        // 認証URLを生成して読み込み開始
        if(!self.isLoaded){
            let config = RequestConfig(
                url: URL(string: "https://accounts.google.com/o/oauth2/auth")!,
                method: .GET,
                queryItems: [
                    "key": self.apiCredential!.APIKey,
                    "client_id": self.apiCredential!.clientID,
                    "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
                    "response_type": "code",
                    "scope": self.scope.map({$0.rawValue}).joined(separator: " "),
                    "access_type": "offline"
                ])
            webView.load(config.createURLRequest())
            self.isLoaded = true
        }
    }
    
    /// Inject credentials from other class.
    /// - Parameters:
    ///   - apiKey: Youtube Data API Key
    ///   - clientID: Youtube Data API client ID
    ///   - clientSecret: Youtube Data API client secret
    ///   - scope: scopes that app requires from user
    ///   - success: callback when authorize succeeded.
    ///   - failure: callback when authorize failed.
    public func configure(apiCredential: YoutubeKit.APICredential, scope: [YoutubeKit.Scope], success: @escaping YoutubeKit.SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping YoutubeKit.FailCallback){
        self.apiCredential = apiCredential
        self.scope = scope
        
        self.successCallback = success
        self.failureCallback = failure
    }
    
    @IBAction func onTapBackButton(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @IBAction func onTapForwardButton(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @IBAction func onTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AuthViewController: WKNavigationDelegate{
    
    // エラーハンドリング
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // プログレスバーを左端に戻して
        UIView.animate(withDuration: 0.5) {
            self.webProgressBar.alpha = 0
        } completion: { (finished) in
            self.webProgressBar.setProgress(0, animated: true)
        }
        
        // alert
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertActions: [UIAlertAction] = [
            .init(title: "OK", style: .default, handler: nil)
        ]
        alertActions.forEach({alert.addAction($0)})
        present(alert, animated: true, completion: nil)
    }
    
    // document.onload
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // プログレスバーを左端に戻す
        UIView.animate(withDuration: 0.5) {
            self.webProgressBar.alpha = 0
        } completion: { (finished) in
            self.webProgressBar.setProgress(0, animated: true)
        }
        
        // 「認証」または「キャンセル」が押されたとき
        guard let destination = self.webView.url else {return}
        if destination.absoluteString.starts(with: "https://accounts.google.com/o/oauth2/approval/v2"){
            
            // URLをパースして
            let queries = URLComponents(string: destination.absoluteString)!.queryItems
            let response = queries!.filter({$0.name == "response"}).first!.value!
            var parameters: [String: String] = [:]
            response.components(separatedBy: "&")
                .map({$0.components(separatedBy: "=")})
                .forEach({parameters[$0[0]] = $0[1]})
            
            // 拒否した場合は画面を閉じて戻る
            if parameters.index(forKey: "error") != nil {
                self.failureCallback?(YoutubeKit.AuthError.denied)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            // アクセストークン生成用コードを取得
            let code = parameters["code"]!
            
            // ユーザが許可したスコープを取得
            let grantedScopes = parameters["scope"]?
                .components(separatedBy: "%20")
                .map({YoutubeKit.Scope(rawValue: $0)})
                .filter({return $0 != nil})
                .map({$0!})
            
            // 生成!
            self.generateAccessToken(code: code, scope: grantedScopes ?? []) { (credential, error) in
                if let error = error {
                    self.failureCallback?(error)
                }
                if let credential = credential {
                    self.successCallback?(credential)
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    /// generate access token from code.
    ///  - Parameters:
    ///     - code: authorization code.
    ///     - scope: scopes that was granted by user.
    ///     - completion: completion callback.
    public func generateAccessToken(code: String, scope: [YoutubeKit.Scope], completion: ((_ credential: YoutubeKit.AccessCredential?, _ error: YoutubeKit.AuthError?) -> Void)?){
        let query = [
            "code": code,
            "client_id": self.apiCredential!.clientID,
            "client_secret": self.apiCredential!.clientSecret,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
            "grant_type": "authorization_code"
        ]
        let config = RequestConfig(url: URL(string: "https://accounts.google.com/o/oauth2/token")!,method: .POST,queryItems: query)
        
        URLSession.shared.dataTask(with: config.createURLRequest()) { (data, response, error) in
            // ここで発生するエラーはユーザの操作により発生することはないので
            // UIfullyなエラー処理は(多分)必要ない (YoutubeKit.AuthErrorで握り潰してよし)
            if error != nil{
                completion?(nil, .unknown)
                return
            }
            
            // レスポンスが取得できないのはちょっと意味わからん
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                fatalError("Unknown Error has been occured!")
            }
            
            // 2XX以外はエラーとみなす
            guard response.typeOfStatusCode() == .Successful else{
                completion?(nil, .invalidCredential)
                return
            }
            
            // access_tokenを抽出
            struct Response: Codable{
                let access_token: String
                let expires_in: Int
                let refresh_token: String?
                let scope: String
                let token_type: String
            }
            guard let responseBody = try? JSONDecoder().decode(Response.self, from: data) else{
                completion?(nil, .invalidResponse)
                return
            }
            
            // YoutubeKit.Credentialsのインスタンスをsuccessに載せて返す
            let credential: YoutubeKit.AccessCredential
            if #available(iOS 13.0, *) {
                credential = YoutubeKit.AccessCredential(accessToken: responseBody.access_token, refreshToken: responseBody.refresh_token!, expires: Date().addingTimeInterval(TimeInterval(responseBody.expires_in)), grantedScopes: scope)
            } else {
                credential = YoutubeKit.AccessCredential(accessToken: responseBody.access_token, refreshToken: responseBody.refresh_token!, expires: Date().addingTimeInterval(TimeInterval(responseBody.expires_in)), grantedScopes: scope)
            }
            completion?(credential, nil)
        }.resume()
    }
    
}

