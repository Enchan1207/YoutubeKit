//
//  AuthorizemacOS.swift - 認証画面(macOS)
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

#if os(macOS)
import Cocoa

public extension YoutubeKit {
    
    /// Authorize user and generate token.
    ///  - Parameters:
    ///    - scope: scopes that app requires from user
    ///    - success: callback when authorization succeeded.
    ///    - failure: callback when authorization failed.
    @available(macOS 10.13, *)
    func authorize (scope: [YoutubeKit.Scope],
                    success: @escaping SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping FailCallback){
        
        // AuthWindow生成
        let authViewController = AuthViewControllermacOS()
        let authWindow = AuthWindow(contentViewController: authViewController)
        
        // データを渡して
        authViewController.configure(apiCredential: self.apiCredential, scope: scope) { (credential) in
            self.accessCredential = credential
            success(credential)
        } failure: { (error) in
            failure(error)
        }
        
        // 表示
        let windowController = NSWindowController(window: authWindow)
        windowController.showWindow(self)
    }

}
#endif
