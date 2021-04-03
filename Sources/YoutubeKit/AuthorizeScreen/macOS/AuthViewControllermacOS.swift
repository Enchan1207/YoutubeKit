//
//  AuthViewControllermacOS.swift
//  YKDemoiOS
//
//  Created by EnchantCode on 2021/04/03.
//

#if os(macOS)

import Cocoa
import WebKit

class AuthViewControllermacOS: NSViewController {
    
    // MARK: - properties
    
    // credentials
    private var apiCredential: YoutubeKit.APICredential? = nil
    private var scope: [YoutubeKit.Scope] = []
    
    // callback
    private var successCallback: ((_ credential: YoutubeKit.AccessCredential) -> Void)?
    private var failureCallback: ((_ error: YoutubeKit.AuthError) -> Void)?
    
    private var isLoaded: Bool = false
    
    // MARK: - UI components
    
    // components
    private var webView: WKWebView!
    
    // observation token
    private var hostnameObservationToken: NSKeyValueObservation!

    // MARK: - initializers
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented!")
    }
    
    
    // MARK: - view lifecycle
    
    override func loadView() {
        self.webView = .init(frame: .zero)
        self.view = NSView(frame: .init(x: 400, y: 400, width: 400, height: 600))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAutoLayout()
        
        // webView設定
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X) AppleWebKit (KHTML, like Gecko) Version/14.0.3 Safari"
        webView.navigationDelegate = self
        
        self.hostnameObservationToken = webView.observe(\.title) { (object, change) in
            self.title = self.webView.title
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
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
    
    // MARK: - configure methods
    
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
    
    /// setup auto layouts.
    private func setupAutoLayout(){
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webView)
        
        // webview
        let webviewConstraints: [NSLayoutConstraint] = [
            .init(item: webView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            .init(item: webView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            .init(item: webView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            .init(item: webView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        
        // apply
        webviewConstraints.forEach({view.addConstraint($0)})
    }
}

extension AuthViewControllermacOS: WKNavigationDelegate{
    
    // エラーハンドリング
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "Authorization Error"
        alert.informativeText = error.localizedDescription
        alert.addButton(withTitle: "OK")
        alert.runModal()
        self.failureCallback?(YoutubeKit.AuthError.invalidResponse)
        self.view.window?.close()
    }
    
    // document.onload
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
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
                self.view.window?.close()
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
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {return}
                    
                    // 閉じてからじゃないと色々困る
                    self.view.window?.close()
                    if let error = error {
                        self.failureCallback?(error)
                        return
                    }
                    if let credential = credential {
                        self.successCallback?(credential)
                        return
                    }
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

#endif
