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
        Self.quotaCost += quota
    }
    
    /// get quota costs.
    public func getQuota() -> UInt{
        return Self.quotaCost
    }
    
    /// reset current quota.
    public func resetQuota(){
        Self.quotaCost = 0
    }
    
}
