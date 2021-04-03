//
//  ViewController.swift
//  YKDemomacOS
//
//  Created by EnchantCode on 2021/04/03.
//

import YoutubeKit
import Cocoa

class ViewController: NSViewController {

    let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        let scope: [YoutubeKit.Scope] = [.readwrite, .forceSSL, .audit, .upload]
        self.youtube.authorize(scope: scope) { (credential) in
            print(credential)
        } failure: { (error) in
            print(error)
        }
    }
}

