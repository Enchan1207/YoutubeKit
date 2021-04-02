//
//  Scope.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension YoutubeKit {
    
    /// Credential Scopes.
    /// (cf. https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps)
    /// **NOTE**: 日本語版のAPIリファレンスでは、いくつかのスコープに関する情報が欠落しています。
    /// (`force-ssl`, `partner` 等)
    /// 詳細かつ正確な情報に関しては、英語版を参照することをおすすめします。
    enum Scope: String, Codable {
        /// Manage your YouTube account
        case readwrite = "https://www.googleapis.com/auth/youtube"
        
        /// View your YouTube account
        case readonly = "https://www.googleapis.com/auth/youtube.readonly"
        
        /// Manage your YouTube videos
        case upload = "https://www.googleapis.com/auth/youtube.upload"
        
        /// View and manage your assets and associated content on YouTube
        case partner = "https://www.googleapis.com/auth/youtubepartner"
        
        /// View private information of your YouTube channel relevant during the audit process with a YouTube partner
        case audit = "https://www.googleapis.com/auth/youtubepartner-channel-audit"
        
        /// See a list of your current active channel members, their current level, and when they became a member
        case memberships = "https://www.googleapis.com/auth/youtube.channel-memberships.creator"
        
        /// See, edit, and permanently delete your YouTube videos, ratings, comments and captions
        case forceSSL = "https://www.googleapis.com/auth/youtube.force-ssl"
    }
}
