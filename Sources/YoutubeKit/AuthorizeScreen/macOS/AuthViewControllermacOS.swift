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
    private let webView: WKWebView!
    private let progressBar: NSProgressIndicator!
    
    // observation token
    private var hostnameObservationToken: NSKeyValueObservation!
    private var progressObservationToken: NSKeyValueObservation!
    private var navigationGoBackObservationToken: NSKeyValueObservation!
    private var navigationGoForwardObservationToken: NSKeyValueObservation!
    
    // MARK: - initializers
    
    init(){
        self.webView = .init(frame: .zero)
        self.progressBar = .init(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented!")
    }
    
    
    // MARK: - view lifecycle
    
    override func loadView() {
        self.view = NSView(frame: .init(x: 400, y: 400, width: 400, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

#endif
