//
//  CollectionResource.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Foundation

public struct CollectionResource<T: Serializable>: Serializable{
    public let kind: String?
    public struct PageInfo: Codable{
        public let totalResults: Int
        public let resultsPerPage: Int
    }
    public let pageInfo: PageInfo?
    
    public let prevPageToken: String?
    public let nextPageToken: String?
    
    public let items: [T]
}
