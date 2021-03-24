//
//  Credentials.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension YoutubeKit {
    // API系
    struct APICredential{
        let APIKey: String
        let clientID: String
        let clientSecret: String
        
        public init(apikey: String, clientID: String, clientSecret: String) {
            self.APIKey = apikey
            self.clientID = clientID
            self.clientSecret = clientSecret
        }
    }
    
    // ユーザ系
    struct AccessCredential: Serializable{
        var accessToken: String
        var refreshToken: String
        var expires: Date = Date()
        var grantedScopes: [YoutubeKit.Scope] = []
        
        public init(accessToken: String, refreshToken: String, expires: Date, grantedScopes: [YoutubeKit.Scope]){
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.expires = expires
            self.grantedScopes = grantedScopes
        }

        public func isOutdated() -> Bool{
            return Date() > expires
        }
    }
}
