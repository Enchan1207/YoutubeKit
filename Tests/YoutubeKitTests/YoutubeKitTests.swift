//
//  YoutubeKitTests.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import XCTest
@testable import YoutubeKit

final class YoutubeKitTests: XCTestCase {
    
    var youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
    
    // setup
    override func setUpWithError() throws {
        // アクセストークン更新
        print("Update Access Credential...", terminator: "")
        do {
            try updateAccessToken()
        } catch {
            print("Failed.")
            throw error
        }
        print("Succeeded.")
    }
    
    // アクセストークン更新
    func updateAccessToken() throws{
        let sema = DispatchSemaphore(value: 0)
        var isSucceeded: Bool = false

        self.youtube.updateToken(success: { (credential) in
            print(credential)
            isSucceeded = true
            sema.signal()
        }, failure: { (error) in
            print(error)
            isSucceeded = false
            sema.signal()
        })
        sema.wait()
        
        if isSucceeded == nil{
            throw YoutubeKit.AuthError.invalidCredential
        }
    }
    
    
    /// Channelsエンドポイントのテスト
    func testGetChannel() throws{
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        self.youtube.getChannel(mine: true) { (result) in
            print(result.serialize()!)
            sema.signal()
        } failure: { (_error) in
            error = _error
            sema.signal()
        }
        sema.wait()
        
        guard error != nil else {return}
        throw error!
    }
    

    static var allTests = [
        ("testGetChannel", testGetChannel),
    ]
}
