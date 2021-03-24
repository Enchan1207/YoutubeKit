//
//  PlaylistResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/23.
//

import Foundation

public struct PlaylistResource: Serializable {
    
    // MARK: - initializers
    public init(id: String = "", title: String, description: String = "", privacyStatus: PrivacyStatus = .Private, tags: [String]? = nil){
        
        self.id = id
        self.snippet = Snippet(publishedAt: "", channelId: "", title: title, description: description, thumbnails: nil, channelTitle: nil, tags: tags)
        self.status = Status(privacyStatus: privacyStatus)
    }
    
    // MARK: - parameters
    public let id: String
    
    public struct Snippet: Codable{
        public let publishedAt: String
        public let channelId: String
        public var title: String
        public var description: String
        
        public struct Thumbnail: Codable{
            public let url: URL
            public let width: Int
            public let height: Int
        }
        public let thumbnails: [String: Thumbnail]?
        
        public let channelTitle: String?
        public let tags: [String]?
    }
    public var snippet: Snippet
    
    public struct Status: Codable {
        public var privacyStatus: PrivacyStatus
    }
    public var status: Status?
}
