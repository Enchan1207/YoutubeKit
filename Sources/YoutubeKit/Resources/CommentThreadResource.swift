//
//  CommentThreadResource.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import Serializable
import Foundation

public struct CommentThreadResource: Serializable, CustomStringConvertible {
    
    // MARK: - parameters
    
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
    
    // MARK: - properties
    
    public var description: String{
        get{
            let toplevelComment = "id: \(self.id) content: \(self.snippet?.topLevelComment?.snippet?.textOriginal ?? "(No content)")"
            let repliyComments: String
            if let replies = self.replies?.comments{
                repliyComments = replies.map({"\($0)"}).joined(separator: "\n\t\t")
            }else{
                repliyComments = "(No reply)"
            }
            return "Top-level comment: \n\t\(toplevelComment)\nreplies:\n\t\t\(repliyComments)"
        }
    }
    
    // MARK: - initializers
    
    public init(channelID: String, videoID: String?, content: String){
        self.id = ""
        self.snippet = .init(channelId: channelID, videoId: videoID, topLevelComment: .init(parentID: "", content: content), canReply: nil, totalReplyCount: nil, isPublic: nil)
        self.replies = nil
    }
}

