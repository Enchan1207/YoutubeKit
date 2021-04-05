//
//  QuotaCostTests.swift
//  
//
//  Created by EnchantCode on 2021/04/05.
//

import XCTest
@testable import YoutubeKit

final class QuotaCostTests: XCTestCase {
    
    ///
    func testSetQuotaCosts() throws{
        // 単純にインスタンスからコストを設定
        let youtube_1 = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
        youtube_1.addQuota(10)
        XCTAssertEqual(youtube_1.getQuota(), YoutubeKit.quotaCost)
        
        // 他のインスタンスからはどう?
        let youtube_2 = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
        XCTAssertEqual(youtube_2.getQuota(), youtube_1.getQuota())
        
        youtube_2.addQuota(10)
        XCTAssertEqual(youtube_2.getQuota(), YoutubeKit.quotaCost)
        
        XCTAssertEqual(youtube_2.getQuota(), youtube_1.getQuota())
        
        // リセットすると?
        youtube_2.resetQuota()
        XCTAssertEqual(youtube_2.getQuota(), youtube_1.getQuota())
        
    }
    
    func testAutoResetQuotaTests() throws {
        let youtube_1 = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
        
        print(YoutubeKit.quotaLastModified)
    }
    
    func testGetResetDate() throws {
        let youtube_1 = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
        
        let resetDate = youtube_1.getResetDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "Y/M/d hh:mm:ss"
        print(formatter.string(from: resetDate))
    }
    
    
    /// Testcases
    static var allTests = [
        ("testSetQuotaCosts", testSetQuotaCosts),
        ("testAutoResetQuotaTests", testAutoResetQuotaTests),
        ("testGetResetDate", testGetResetDate)
    ]
}
