//
//  VideoRateResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Serializable
import Foundation

public struct VideoRateReasource: Serializable {
    public struct RateItem: Codable {
        public let videoId: String
        public let rating: YoutubeKit.Rate
    }
    public let items:[RateItem]?
}
