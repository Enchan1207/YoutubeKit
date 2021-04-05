//
//  Channels.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Serializable
import Foundation

/// endpoint callers about Channels (https://developers.google.com/youtube/v3/docs/channels/list)
public extension YoutubeKit {
    
    /// Get channel.
    /// (cf. https://developers.google.com/youtube/v3/docs/channels/list?hl=ja)
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
        let part: [YoutubeKit.Part] = [.id, .snippet, .contentDetails, .statistics, .topicDetails]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["categoryId"] = categoryId
        queryItems["forUsername"] = forUsername
        queryItems["id"] = id?.joined(separator: ",")
        queryItems["mine"] = mine
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/channels")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 1, success: { (response) in
            guard let playlists = CollectionResource<ChannelResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
    /// Update channel.
    /// (cf. https://developers.google.com/youtube/v3/docs/channels/update?hl=ja)
    /// **WARNING: FrameworkがinvideoPromotionに対応していないので実質動きません**
    func updateChannel(target: ChannelResource,
                       success: @escaping SuccessCallback<ChannelResource>, failure: @escaping FailCallback) {
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/channels")!, method: .PUT, requestHeader: requestHeader, requestBody: target.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 50, success: { (response) in
            guard let playlist = ChannelResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlist)
        }, failure: failure)
    }
    
}
