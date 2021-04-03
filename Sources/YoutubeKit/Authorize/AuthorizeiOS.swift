//
//  AuthorizeiOS.swift - 認証画面(iOS)
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

#if os(iOS)
import UIKit
import Foundation

public extension YoutubeKit {
    
    /// Authorize user and generate token.
    ///  - Parameters:
    ///    - presentViewController: viewcontroller that shows authorization screen.
    ///    - scope: scopes that app requires from user
    ///    - success: callback when authorization succeeded.
    ///    - failure: callback when authorization failed.
    @available(iOS 11.0, *)
    func authorize (presentViewController: UIViewController,
                    scope: [YoutubeKit.Scope],
                    success: @escaping SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping FailCallback){
        
        // AuthViewControllerを生成
        let authNavigationController = AuthNavigationController()
        let authViewController = authNavigationController.children.first as! AuthViewControlleriOS

        // データを渡して
        authViewController.configure(apiCredential: self.apiCredential, scope: scope) { (credential) in
            self.accessCredential = credential
            success(credential)
        } failure: { (error) in
            failure(error)
        }

        // 表示
        presentViewController.present(authNavigationController, animated: true, completion: nil)
    }

}
#endif
