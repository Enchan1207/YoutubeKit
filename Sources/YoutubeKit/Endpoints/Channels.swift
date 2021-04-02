//
//  Channels.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

/// endpoint callers about Channels (https://developers.google.com/youtube/v3/docs/channels/list)
public extension YoutubeKit {
    
    /// Get channel.
    ///  - Parameters:
    ///     -
    func getChannel(mine: Bool? = nil,
                    id: [String]? = nil,
                    forUsername: String? = nil,
                    categoryId: String? = nil,
                    maxResults: Int? = nil,
                    pageToken: String? = nil,
                    success: @escaping SuccessCallback<CollectionResource<ChannelResource>>, failure: @escaping FailCallback){
        
        // バリデーション
        if categoryId == nil && forUsername == nil && id == nil && mine == nil {
            failure(APIError.filterError("No filter selected."))
        }
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet, .brandingSettings, .contentDetails, .invideoPromotion, .statistics, .topicDetails]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["categoryId"] = categoryId
        queryItems["forUsername"] = forUsername
        queryItems["id"] = id?.joined(separator: ",")
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/channels")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            print(response)
            guard let playlists = CollectionResource<ChannelResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize playlist items"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
}
