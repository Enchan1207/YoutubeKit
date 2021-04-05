//
//  ChannelResource.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import Serializable
import Foundation

public struct ChannelResource: Serializable{
    
    public let id: String
    
    public struct Snippet: Codable{
        public let title: String
        public let description: String
        public let publishedAt: String
        public struct Thumbnail: Codable{
            public let url: URL?
            public let width: Int?
            public let height: Int?
        }
        public let thumbnails: [String: Thumbnail]?
    }
    public let snippet: Snippet?
    
    public struct ContentDetails: Codable{
        public struct relatedPlaylists: Codable{
            public let likes: String?
            public let favorites: String?
            public let uploads: String?
            public let watchHistory: String?
            public let watchLater: String?
        }
        public let googlePlusUserId: String?
    }
    public let contentDetails: ContentDetails?
    
    public struct Statistics: Codable{
        public let viewCount: String?
        public let commentCount: String?
        public let subscriberCount: String?
        public let hiddenSubscriberCount: Bool?
        public let videoCount: String?
    }
    public let statistics: Statistics?
    
    public struct TopicDetails: Codable{
        public let topicIds: [String]?
    }
    public let topicDetails: TopicDetails?
    
    public struct Status: Codable{
        public let privacyStatus: String?
        public let isLinked: Bool?
    }
    public let status: Status?
}
