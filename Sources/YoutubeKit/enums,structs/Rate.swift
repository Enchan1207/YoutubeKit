//
//  Rate.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Foundation

public extension YoutubeKit{
    enum Rate: String, Codable{
        case like
        case dislike
        case none
        case unspecified
    }
}
