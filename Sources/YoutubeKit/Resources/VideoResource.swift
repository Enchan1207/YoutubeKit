//
//  VideoResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Serializable
import Foundation

public struct VideoResource: Serializable {
    
    public let id: String?
    
    // MARK: - snippet
    public struct Snippet: Codable{
        public let publishedAt: String?
        public let channelId: String?
        public var title: String?
        public var description: String?
        public struct Thumbnail: Codable{
            public let url: URL?
            public let width: Int?
            public let height: Int?
        }
        public let thumbnails: [String: Thumbnail]?
        public let channelTitle: String?
        public let tags: [String]?
        public let categoryId: String?
    }
    public let snippet: Snippet?
    
    // MARK: - contentDetails
    public struct ContentDetails: Codable{
        public let duration: String?
        public let dimension: String?
        public let definition: String?
        public let caption: String?
        public let licensedContent: Bool?
        public struct RegionRestriction: Codable{
            public let allowed: [String]?
            public let blocked: [String]?
        }
        public let regionRestriction: RegionRestriction?
        public let contentRating: [String: String]?
        public let projection: String?
    }
    public let contentDetails: ContentDetails?
    
    // MARK: - status
    public struct Status: Codable{
        public let uploadStatus: String?
        public let failureReason: String?
        public let rejectionReason: String?
        public let privacyStatus: String?
        public let license: String?
        public let embeddable: Bool?
        public let publicStatsViewable: Bool?
    }
    public let status: Status?
    
    // MARK: - statistics
    public struct Statistics: Codable{
        public let viewCount: String?
        public let likeCount: String?
        public let dislikeCount: String?
        public let favoriteCount: String?
        public let commentCount: String?
    }
    public let statistics: Statistics?
    
    // MARK: - player
    public struct Player: Codable{
        public let embedHtml: String?
    }
    public let player: Player?
    
    // MARK: - topicDetails
    public struct TopicDetails: Codable{
        public let topicIds: [String]?
        public let relevantTopicIds: [String]?
        public let topicCategories: [String]?
    }
    public let topicDetails: TopicDetails?
    
    // MARK: - recordingDetails
    public struct RecordingDetails: Codable{
        public let locationDescription: String?
        public struct Location: Codable{
            public let latitude: String?
            public let longitude: String?
            public let altitude: String?
        }
        public let location: Location?
        public let recordingDate: String?
    }
    public let recordingDetails: RecordingDetails?
    
    // MARK: - fileDetails
    public struct FileDetails: Codable{
        public let fileName: String?
        public let fileSize: String?
        public let fileType: String?
        public let container: String?
        public struct VideoStreams: Codable{
            public let widthPixels: String?
            public let heightPixels: String?
            public let frameRateFps: String?
            public let aspectRatio: String?
            public let codec: String?
            public let bitrateBps: String?
            public let rotation: String?
            public let vendor: String?
        }
        public let videoStreams: [VideoStreams]?
        public struct AudioStreams: Codable{
            public let channelCount: String?
            public let codec: String?
            public let bitrateBps: String?
            public let vendor: String?
        }
        public let audioStreams: [AudioStreams]?
        public let durationMs: String?
        public let bitrateBps: String?
        public struct RecordingLocation: Codable{
            public let latitude: String?
            public let longitude: String?
            public let altitude: String?
        }
        public let recordingLocation: RecordingLocation?
        public let creationTime: String?
    }
    public let fileDetails: FileDetails?
    
    // MARK: - processingDetails
    public struct ProcessingDetails: Codable{
        public let processingStatus: String?
        public struct ProcessingProgress: Codable{
            public let partsTotal: String?
            public let partsProcessed: String?
            public let timeLeftMs: String?
        }
        public let processingProgress: ProcessingProgress?
        public let processingFailureReason: String?
        public let fileDetailsAvailability: String?
        public let processingIssuesAvailability: String?
        public let tagSuggestionsAvailability: String?
        public let editorSuggestionsAvailability: String?
        public let thumbnailsAvailability: String?
    }
    public let processingDetails: ProcessingDetails?
    
    // MARK: - suggestions
    public struct Suggestions: Codable{
        public let processingErrors: [String]?
        public let processingWarnings: [String]?
        public let processingHints: [String]?
        public struct TagSuggestions: Codable{
            public let tag: String?
            public let categoryRestricts: [String]?
        }
        public let tagSuggestions: [TagSuggestions]?
        public let editorSuggestions: [String]?
    }
    public let suggestions: Suggestions?
    
}
