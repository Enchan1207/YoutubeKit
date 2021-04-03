//
//  AuthViewController.swift
//  YKDemoiOS
//
//  Created by EnchantCode on 2021/04/03.
//

#if os(OSX)

import Cocoa

open class AuthViewControllermacOS: NSViewController {

    // MARK: - initializers
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("\(#function) is not implemeted!")
    }
    
    // MARK: - view lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

#endif
