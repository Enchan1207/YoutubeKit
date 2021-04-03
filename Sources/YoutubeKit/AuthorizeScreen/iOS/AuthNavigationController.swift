//
//  AuthNavigationController.swift
//  CodeBaseVCEx
//
//  Created by EnchantCode on 2021/03/25.
//

#if os(iOS)

import UIKit

open class AuthNavigationController: UINavigationController {
    
    private var authViewController: AuthViewControlleriOS!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("\(#file): \(#function) is not implemented!!")
    }
    
    init(){
        self.authViewController = AuthViewControlleriOS()
        super.init(rootViewController: self.authViewController)
    }
}

#endif
