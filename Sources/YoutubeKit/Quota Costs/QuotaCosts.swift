//
//  QuotaCosts.swift
//  
//
//  Created by EnchantCode on 2021/04/05.
//

import Foundation

extension YoutubeKit {
    
    /// add quota costs.
    func addQuota(_ quota: UInt){
        _ = resetQuotaIfNeeded()
        Self.quotaLastModified = Date()
        Self.quotaCost += quota
    }
    
    /// reset quota if needed.
    func resetQuotaIfNeeded(_ now: Date = .init()) -> Bool {
        
        // lastmodifiedの日のリセット日時
        let resetDate = getResetDate(Self.quotaLastModified)
        
        // lastModifiedがそれより後(つまり、今後最大24時間はリセットされない)ならreturn
        guard Self.quotaLastModified <= resetDate else { return false }
        
        // リセット日時が現在日時より後(つまり、lastmodified -> now -> resetDate)ならreturn
        guard Self.quotaLastModified <= now else { return false }
        
        // RESET
        resetQuota()
        return true
    }
    
    /// get today's reset date.
    func getResetDate(_ date: Date = .init()) -> Date {
        let calender = Calendar.current
        let resetDate = calender.date(byAdding: .hour,
                                      value: 8,
                                      to: calender.startOfDay(for: date))
        return resetDate!
    }
    
    /// get quota costs.
    public func getQuota() -> UInt{
        _ = resetQuotaIfNeeded()
        return Self.quotaCost
    }
    
    /// reset current quota.
    public func resetQuota(){
        Self.quotaCost = 0
    }
    
}
