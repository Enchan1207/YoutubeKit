//
//  YoutubeKitTests.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import XCTest
@testable import YoutubeKit

final class YoutubeKitTests: XCTestCase {
    
    var isTokenUpdated = false
    var youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
    
    // setup
    override func setUpWithError() throws {
        
        if !isTokenUpdated{
            isTokenUpdated = true
            // アクセストークン更新
            print("アクセストークンを更新しています…")
            do {
                try updateAccessToken()
            } catch {
                print("エラーが発生しました")
                throw error
            }
            print("完了")
        }
    }
    
    // アクセストークン更新
    func updateAccessToken() throws{
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.youtube.updateToken(success: { (credential) in
            print("トークン: \(credential.accessToken)\n更新トークン: \(credential.refreshToken)\n期限: \(credential.expires)")
            sema.signal()
        }, failure: { (_error) in
            error = _error
            sema.signal()
        })
        sema.wait()
        
        guard error != nil else {return}
        throw error!
    }
    
    /// Channelsエンドポイントのテスト
    func testGetChannel() throws {
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
    
    /// Searchエンドポイントのテスト
    func testSearch() throws {
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.youtube.search(query: "Swift Programming language", maxResults: 40) { (result) in
            for item in result.items{
                print(item.serialize()!)
            }
            sema.signal()
        } failure: { (_error) in
            error = _error
            sema.signal()
        }
        
        
        sema.wait()
        guard error != nil else {return}
        throw error!
    }
    
    /// CommentThreadエンドポイントのテスト
    func testGetCommentThread() throws {
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        self.youtube.getCommentThread(videoId: "CXHuBvvrlsw", maxResults: 100, order: .relevance, textFormat: .plainText) { (result) in
            let threads = result.items
            for thread in threads{
                print(thread.serialize()!)
            }
            sema.signal()
        } failure: { (_error) in
            error = _error
            sema.signal()
        }
        sema.wait()
        
        guard error != nil else {return}
        throw error!
    }
    
    /// Commentエンドポイントのテスト
    func testComment() throws {
        let sema = DispatchSemaphore(value: 0)
        var error:Error? = nil
        self.youtube.getComment(id: ["UgzMg9Oq9y-uKs3zq1l4AaABAg"], textFormat: .plainText) { (result) in
            print(result)
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
        ("testGetCommentThread", testGetCommentThread),
        ("testSearch", testSearch),
        ("testComment", testComment),
    ]
}
