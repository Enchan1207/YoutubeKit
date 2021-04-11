//
//  Credentials.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Serializable
import Foundation

public extension YoutubeKit {
    // API系
    struct APICredential: Serializable{
        public let APIKey: String
        public let clientID: String
        public let clientSecret: String
        
        public init(apikey: String, clientID: String, clientSecret: String) {
            self.APIKey = apikey
            self.clientID = clientID
            self.clientSecret = clientSecret
        }
    }
    
    // ユーザ系
    struct AccessCredential: Serializable{
        internal (set) public var accessToken: String
        internal (set) public var refreshToken: String
        internal (set) public var expires: Date = Date()
        internal (set) public var grantedScopes: [YoutubeKit.Scope] = []
        
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
