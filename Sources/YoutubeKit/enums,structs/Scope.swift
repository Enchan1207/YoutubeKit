//
//  Scope.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension YoutubeKit {
    
    enum Scope: String, Codable {
        case readwrite = "https://www.googleapis.com/auth/youtube"
        case readonly = "https://www.googleapis.com/auth/youtube.readonly"
        case upload = "https://www.googleapis.com/auth/youtube.upload"
        case audit = "https://www.googleapis.com/auth/youtubepartner-channel-audit"
    }
}
