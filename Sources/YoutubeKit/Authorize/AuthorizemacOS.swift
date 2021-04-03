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
    ///    - presentViewController: viewcontroller that shows authorization screen.
    ///    - scope: scopes that app requires from user
    ///    - success: callback when authorization succeeded.
    ///    - failure: callback when authorization failed.
    @available(macOS 10.13, *)
    func authorize (presentViewController: NSViewController,
                    scope: [YoutubeKit.Scope],
                    success: @escaping SuccessCallback<YoutubeKit.AccessCredential>, failure: @escaping FailCallback){
        
        // MARK: TODO macOS版authorize()
        fatalError("\(#function) is not implemented!")
        
    }

}
#endif
