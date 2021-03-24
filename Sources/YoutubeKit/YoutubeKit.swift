//
//  YoutubeKit.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public class YoutubeKit {
    public typealias SuccessCallback<T> = (_ response: T) -> Void
    public typealias FailCallback = (_ error: Error) -> Void
    
    // credentials
    public let apiCredential: APICredential
    public var accessCredential: AccessCredential?
    
    /// Generate Instance.
    /// - Parameters:
    ///    - accessCredential: Credentials of Youtube Data API
    ///    - clientID: Youtube Data API client ID
    public init(apiCredential: APICredential, accessCredential: AccessCredential?){
        self.apiCredential = apiCredential
        self.accessCredential = accessCredential
    }
}
