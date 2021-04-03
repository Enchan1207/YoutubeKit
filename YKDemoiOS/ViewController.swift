//
//  ViewController.swift
//  YKDemoiOS
//
//  Created by EnchantCode on 2021/04/03.
//

import UIKit
import YoutubeKit

class ViewController: UIViewController {
    
    let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let scope: [YoutubeKit.Scope] = [.readwrite, .forceSSL, .audit, .upload]
        self.youtube.authorize(presentViewController: self, scope: scope) { (credential) in
            print(credential)
        } failure: { (error) in
            print(error)
        }
    }
}

