//
//  Part.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/23.
//

import Foundation

public extension YoutubeKit{
    
    /// Resource properties that the API response will include.
    enum Part: RawRepresentable {
        case contentDetails
        case id
        case localizations
        case player
        case snippet
        case status
        case fileDetails
        case liveStreamingDetails
        case processingDetails
        case recordingDetails
        case statistics
        case suggestions
        case topicDetails
        
        case invideoPromotion
        case brandingSettings
        
        case other(String)
        
        public init(rawValue: String) {
            self = .other(rawValue)
        }
        
        public var rawValue: String{
            get{
                switch self {
                case let Part.other(value):
                    return value
                default:
                    return "\(self)"
                }
            }
        }
    }
}
