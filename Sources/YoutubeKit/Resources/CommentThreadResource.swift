//
//  CommentThreadResource.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

public struct CommentThreadResource: Serializable {
    public let id: String

    public struct Snippet: Codable{
        public let channelId: String?
        public let videoId: String?
        public let topLevelComment: CommentResource?
        public let canReply: Bool?
        public let totalReplyCount: UInt?
        public let isPublic: Bool?
    }
    public let snippet: Snippet?

    public struct Reply: Codable{
        public let comments: [CommentResource]?
    }
    public let replies: Reply?
}

