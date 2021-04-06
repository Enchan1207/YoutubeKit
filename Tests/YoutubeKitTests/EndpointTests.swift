//
//  EndpointTests.swift
//  APIエンドポイントのテスト (⌘Uで回りますが実際にAPIを叩いてしまうので注意)
//
//  Created by EnchantCode on 2021/04/02.
//

import XCTest
@testable import YoutubeKit

final class EndpointTests: XCTestCase {
    
    var youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)

    /// Channels (GET)
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
    
    /// Search (GET)
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
    
    /// CommentThread (GET)
    func testGetCommentThread() throws {
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        self.youtube.getCommentThread(videoId: "GEZhD3J89ZE", maxResults: 100, order: .relevance, textFormat: .plainText) { (result) in
            for thread in result.items{
                print(thread)
                print("")
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
    
    func testGetCommentThreadByChannel() throws {
        let targetID = "UCgMPP6RRjktV7krOfyUewqw"
        
        let sema = DispatchSemaphore(value: 0)
        var error: Error? = nil
        self.youtube.getCommentThread(channelId: targetID, order: .relevance) { (result) in
            for thread in result.items{
                print(thread)
                print("")
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
    
    /// Comment (GET)
    func testComment() throws {
        let sema = DispatchSemaphore(value: 0)
        var error:Error? = nil
        self.youtube.getComment(id: [""], textFormat: .plainText) { (result) in
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

    /// CommentThread (POST)
    func testInsertCommentThread() throws {
        let sema = DispatchSemaphore(value: 0)
        var error: Error?
        
        let commentThread = CommentThreadResource(channelID: "", videoID: nil, content: "")
        self.youtube.insertCommentThread(new: commentThread) { (result) in
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
    
    /// Testcases
    static var allTests = [
        ("testGetChannel", testGetChannel),
        ("testSearch", testSearch),
        ("testGetCommentThread", testGetCommentThread),
        ("testComment", testComment),
        ("testInsertCommentThread", testInsertCommentThread),
    ]
}
