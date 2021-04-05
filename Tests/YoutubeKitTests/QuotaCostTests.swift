//
//  QuotaCostTests.swift
//  
//
//  Created by EnchantCode on 2021/04/05.
//

import XCTest
@testable import YoutubeKit

final class QuotaCostTests: XCTestCase {
    
    let youtube_1 = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
    
    ///
    func testSetQuotaCosts() throws{
        // 単純にインスタンスからコストを設定
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
    
    func testAutoResetQuotaFailPattern() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y/M/d hh:mm:ss"
        
        // 失敗パターン
        
        // 1. lastmodifiedがリセット日時より後
        let lastModified_1: Date = formatter.date(from: "2021/04/05 08:01:00")!
        let now_1: Date = formatter.date(from: "2021/04/05 09:00:00")!
        YoutubeKit.quotaLastModified = lastModified_1
        let result_1 = youtube_1.resetQuotaIfNeeded(now_1)
        XCTAssertFalse(result_1)
        
        // 2. 現在時刻がリセット日時より前
        let lastModified_2: Date = formatter.date(from: "2021/04/05 08:01:00")!
        let now_2: Date = formatter.date(from: "2021/04/05 07:59:00")!
        YoutubeKit.quotaLastModified = lastModified_2
        let result_2 = youtube_1.resetQuotaIfNeeded(now_2)
        XCTAssertFalse(result_2)
    }
    
    func testAutoResetQuotaSuccessPattern() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y/M/d hh:mm:ss"
        
        // 成功パターン
        
        // lastmodified -> reset -> now の順
        let lastModified_1: Date = formatter.date(from: "2021/04/05 07:01:00")!
        let now_1: Date = formatter.date(from: "2021/04/05 09:00:00")!
        YoutubeKit.quotaLastModified = lastModified_1
        let result_1 = youtube_1.resetQuotaIfNeeded(now_1)
        XCTAssertTrue(result_1)
    }
    
    func testGetResetDate() throws {
        let resetDate = youtube_1.getResetDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "Y/M/d hh:mm:ss"
        print(formatter.string(from: resetDate))
    }
    
    /// Testcases
    static var allTests = [
        ("testSetQuotaCosts", testSetQuotaCosts),
        ("testAutoResetQuotaFailPattern", testAutoResetQuotaFailPattern),
        ("testGetResetDate", testGetResetDate)
    ]
}
