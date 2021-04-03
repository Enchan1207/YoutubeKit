//
//  Authorize.swift
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
            fatalError("generated viewcontroller is not type of AuthViewController. the children of navigation controller is: \(navigationController.children)")
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

}
#endif
