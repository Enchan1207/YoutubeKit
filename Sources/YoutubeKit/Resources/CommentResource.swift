//
//  CommentResource.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

public struct CommentResource: Serializable {
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
}
