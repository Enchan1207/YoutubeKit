//
//  AuthViewControllermacOS.swift
//  YKDemoiOS
//
//  Created by EnchantCode on 2021/04/03.
//

#if os(macOS)

import Cocoa

class AuthViewControllermacOS: NSViewController {
    
    // MARK: - view lifecycle
    
    override func loadView() {
        self.view = NSView(frame: .init(x: 400, y: 400, width: 400, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

#endif
