//
//  CommentResource.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Serializable
import Foundation

public struct CommentResource: Serializable, CustomStringConvertible {
    
    // MARK: - parameters
    
    public let id: String

    public struct Snippet: Codable{
        public let authorDisplayName: String?
        public let authorProfileImageUrl: String?
        public let authorChannelUrl: String?
        public struct AuthorChannelId: Codable{
            public let value: String?
        }
        public let authorChannelId: AuthorChannelId?
        public let channelId: String?
        public let videoId: String?
        public let textDisplay: String?
        public let textOriginal: String?
        public let parentId: String?
        public let canRate: Bool?
        public let viewerRating: String?
        public let likeCount: UInt?
        public let moderationStatus: String?
        public let publishedAt: String?
        public let updatedAt: String?
    }
    public let snippet: Snippet?
    
    // MARK: - properties
    
    public var description: String{
        get{
            let content: String
            if let snippet = self.snippet {
                content = snippet.textOriginal ?? "(No content)"
            }else{
                content = "(No snippet)"
            }
            return "id: \(self.id) content: \(content)"
        }
    }
    
    // MARK: - initializers
    
    public init(parentID: String, content: String){
        self.id = ""
        self.snippet = .init(authorDisplayName: nil, authorProfileImageUrl: nil, authorChannelUrl: nil, authorChannelId: nil, channelId: nil, videoId: nil, textDisplay: nil, textOriginal: content, parentId: parentID, canRate: nil, viewerRating: nil, likeCount: nil, moderationStatus: nil, publishedAt: nil, updatedAt: nil)
    }
}
