//
//  SearchResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Foundation

public struct SearchResource: Serializable {
    
    // MARK: - parameters
    
    public enum Kind: String, Codable{
        case video = "youtube#video"
        case channel = "youtube#channel"
        case playlist = "youtube#playlist"
    }
    
    struct _SearchID: Codable {
        let kind: Kind?
        let videoId: String?
        let channelId: String?
        let playlistId: String?
    }
    let id: _SearchID?
    
    public var kind: Kind? {
        get{
            return self.id?.kind
        }
    }
    
    public struct Snippet: Codable{
        public let publishedAt: String
        public let channelId: String
        public var title: String
        public var description: String
        
        public struct Thumbnail: Codable{
            public let url: URL
            public let width: Int?
            public let height: Int?
        }
        public let thumbnails: [String: Thumbnail]?
        
        public let channelTitle: String?
    }
    public var snippet: Snippet
    
    // MARK: - functions
    
    public func getID() -> String?{
        switch self.kind {
        case .channel: return self.id?.channelId
        case .video: return self.id?.videoId
        case .playlist: return self.id?.playlistId
        default: return nil
        }
    }
}
