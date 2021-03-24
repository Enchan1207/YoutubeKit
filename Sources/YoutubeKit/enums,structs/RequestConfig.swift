//
//  RequestConfig.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation
import WebKit

public struct RequestConfig {
    let url: URL
    var method: HTTPMethod = .GET
    var requestHeader: [String: Any] = [:]
    var requestBody: Data? = nil
    var queryItems: [String: Any] = [:]
    
    public init(url: URL, method: HTTPMethod, requestHeader: [String: Any]? = nil, requestBody: Data? = nil, queryItems: [String: Any]? = nil){
        self.url = url
        self.method = method
        self.requestHeader = requestHeader ?? [:]
        self.requestBody = requestBody
        self.queryItems = queryItems ?? [:]
    }
    
    // configからURLRequestを生成
    public func createURLRequest() -> URLRequest {
        var components = URLComponents(url: self.url, resolvingAgainstBaseURL: false)!
        components.queryItems = self.queryItems.map({URLQueryItem(name: $0.key, value: "\($0.value)")})
        let requestURL = components.url!
        
        var req = URLRequest(url: requestURL)
        req.httpMethod = self.method.rawValue
        req.httpBody = self.requestBody
        self.requestHeader.forEach({req.setValue("\($0.value)", forHTTPHeaderField: $0.key)})
        
        return req
    }
}

public enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PATCH
    case PUT
}
