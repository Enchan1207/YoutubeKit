//
//  Error.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension YoutubeKit {
    enum AuthError: Error {
        case denied
        case invalidToken
        case invalidCredential
        case invalidResponse
        case loginRequired
        case unknown
    }
    
    enum APIError: Error {
        case networkError(Int, String) // with status-code and response
        case filterError(String)
        case requestError(String)
        case codableError(String)
        
        case unknown(String)
    }
}

extension YoutubeKit.AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .denied: return "user denied app to access user data"
        case .invalidCredential: return "invalid internal credentials"
        case .invalidToken: return "invalid access or refresh token"
        case .invalidResponse: return "invalid authorization response"
        case .loginRequired: return "login required."
        default: return "unknown error"
        }
    }
}
