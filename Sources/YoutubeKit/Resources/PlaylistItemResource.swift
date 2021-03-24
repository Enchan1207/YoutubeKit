//
//  PlaylistItemResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Foundation

public struct PlaylistItemResource: Serializable{
    // MARK: - initializers
    public init(id: String = "", playlistId: String, videoId: String, position: UInt = 0, startAt:String? = nil, endAt:String? = nil, note: String? = nil){
        
        self.id = id
        self.snippet = .init(publishedAt: "", channelId: "", title: "", description: "", thumbnails: nil, channelTitle: "", playlistId: playlistId, position: position, resourceId: .init(kind: "youtube#video", videoId: videoId), videoOwnerChannelTitle: nil, videoOwnerChannelId: nil)
        self.contentDetails = .init(videoId: videoId, videoPublishedAt: "", startAt: startAt, endAt: endAt, note: note)
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
        public let playlistId: String?
        public var position: UInt
        
        public struct ResourceID: Codable{
            public let kind: String
            public let videoId: String
        }
        public let resourceId: ResourceID
        
        public let videoOwnerChannelTitle: String?
        public let videoOwnerChannelId: String?
        
    }
    public var snippet: Snippet
    
    public struct ContentDetails: Codable {
        public let videoId: String
        public let videoPublishedAt: String?
        public var startAt: String?
        public var endAt: String?
        public var note: String?
    }
    public var contentDetails: ContentDetails?
    
    public struct Status: Codable {
        public var privacyStatus: PrivacyStatus
    }
    public var status: Status?
}
