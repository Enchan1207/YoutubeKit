//
//  AuthVCExt.swift - AuthViewController
//  
//
//  Created by EnchantCode on 2021/04/03.
//

#if os(iOS)

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    // MARK: - properties
    
    // credentials
    private var apiCredential: YoutubeKit.APICredential? = nil
    private var scope: [YoutubeKit.Scope] = []
    
    // callback
    private var successCallback: ((_ credential: YoutubeKit.AccessCredential) -> Void)?
    private var failureCallback: ((_ error: YoutubeKit.AuthError) -> Void)?
    
    // MARK: - UI components
    
    // components
    private let webView: WKWebView!
    private let toolBar: UIToolbar!
    private let progressBar: UIProgressView!
    
    private var navigationBackButton: UIBarButtonItem!
    private var navigationForwardButton: UIBarButtonItem!
    
    // observation token
    private var hostnameObservationToken: NSKeyValueObservation!
    private var progressObservationToken: NSKeyValueObservation!
    private var navigationGoBackObservationToken: NSKeyValueObservation!
    private var navigationGoForwardObservationToken: NSKeyValueObservation!
    
    // MARK: - initializers
    
    init() {
        // init ui parts
        self.webView = .init()
        self.toolBar = .init(frame: CGRect(x: 0,y: 0,width: 100, height: 100)) // why?
        self.progressBar = .init()
        
        self.navigationBackButton = .init()
        self.navigationForwardButton = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) in \(#file) has not been implemented!")
    }
    
    // MARK: - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // componentsを追加して
        self.view.addSubview(webView)
        self.view.addSubview(toolBar)
        self.view.addSubview(progressBar)
        
        // Autolayout
        webView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        // progressbar
        progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // webview
        webView.topAnchor.constraint(equalTo: progressBar.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // toolbar
        toolBar.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // toolbar設定
        let fixedItem: UIBarButtonItem = .init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedItem.width = 42.0
        
        // UIImage(systemName:)はiOS13以降しか対応していない
        if #available(iOS 13.0, *) {
            let leftButtonImage = UIImage(systemName: "chevron.left")
            let rightButtonImage = UIImage(systemName: "chevron.right")!
            self.navigationBackButton = .init(image: leftButtonImage, landscapeImagePhone: leftButtonImage, style: .plain, target: self, action: #selector(onTapGoBack(_:)))
            self.navigationForwardButton = .init(image: rightButtonImage, landscapeImagePhone: rightButtonImage, style: .plain, target: self, action: #selector(onTapGoForward(_:)))
        } else {
            self.navigationBackButton = .init(title: "back", style: .plain, target: self, action: #selector(onTapGoBack(_:)))
            self.navigationForwardButton = .init(title: "forward", style: .plain, target: self, action: #selector(onTapGoForward(_:)))
        }
        
        // toolbarにボタンを追加
        toolBar.items = [
            self.navigationBackButton,
            fixedItem,
            self.navigationForwardButton,
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        ]
        
        if #available(iOS 13.0, *) {
            toolBar.backgroundColor = .systemBackground
        } else {
            toolBar.backgroundColor = .init(white: 1.0, alpha: 0.85)
        }
        
        // progressbar設定
        progressBar.progressViewStyle = .bar
        
        // webview設定
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTapDone(_:)))
        navigationItem.leftBarButtonItem = doneButtonItem
        hostnameObservationToken = webView.observe(\.title) { (object, change) in
            self.title = self.webView.title
        }
        self.webView.navigationDelegate = self
        
        self.progressObservationToken = webView.observe(\.estimatedProgress) { (object, change) in
            self.progressBar.progress = Float(self.webView.estimatedProgress)
        }
        
        // Can we go back
        self.navigationGoBackObservationToken = webView.observe(\.canGoBack) { (object, change) in
            self.navigationBackButton.isEnabled = self.webView.canGoBack
        }
        
        // Can we go forward
        self.navigationGoForwardObservationToken = webView.observe(\.canGoForward) { (object, change) in
            self.navigationForwardButton.isEnabled = self.webView.canGoForward
        }
        
    }
    
    // MARK: - view events
    
    // "Done"
    @objc func onTapDone(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    // "Back"
    @objc func onTapGoBack(_ sender: UIBarButtonItem){
        self.webView.goBack()
    }
    
    // "Forward"
    @objc func onTapGoForward(_ sender: UIBarButtonItem){
        self.webView.goForward()
        
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
    
}

extension AuthViewController: WKNavigationDelegate{
    
    // エラーハンドリング
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // プログレスバーを左端に戻して
        UIView.animate(withDuration: 0.5) {
            self.progressBar.alpha = 0
        } completion: { (finished) in
            self.progressBar.setProgress(0, animated: true)
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
            self.progressBar.alpha = 0
        } completion: { (finished) in
            self.progressBar.setProgress(0, animated: true)
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
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {return}
                    
                    // 閉じてからじゃないと色々困る
                    self.dismiss(animated: true) {
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
