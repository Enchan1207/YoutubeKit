//
//  AuthNavigationController.swift
//  CodeBaseVCEx
//
//  Created by EnchantCode on 2021/03/25.
//

#if os(iOS)

import UIKit

class AuthNavigationController: UINavigationController {
    
    private var authViewController: AuthViewController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file): \(#function) is not implemented!!")
    }
    
    init(){
        self.authViewController = AuthViewController()
        super.init(rootViewController: self.authViewController)
    }
}

#endif
