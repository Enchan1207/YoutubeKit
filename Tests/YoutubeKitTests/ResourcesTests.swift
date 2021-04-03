//
//  ResourcesTests.swift
//  Resources周りのテスト
//
//  Created by EnchantCode on 2021/04/02.
//

import XCTest
@testable import YoutubeKit

final class ResourcesTests: XCTestCase {
    
    /// CommentResource生成
    func testInstantiateCommentResource() throws {
        let comment = CommentResource(parentID: "12345678", content: "Test Comment!")
        print(comment.serialize()!)
    }
    
    /// CommentThreadResource生成
    func testInstantiateCommentThreadResource() throws {
        let comment = CommentThreadResource(channelID: "", videoID: "", content: "Hello, World!")
        print(comment.serialize()!)
    }
    
    /// Testcases
    static var allTests = [
        ("testInstantiateCommentResource", testInstantiateCommentResource),
        ("testInstantiateCommentThreadResource", testInstantiateCommentThreadResource),
    ]
}
