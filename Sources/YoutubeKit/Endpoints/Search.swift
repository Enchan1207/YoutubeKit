//
//  Search.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Serializable
import Foundation

/// endpoint callers about search (https://developers.google.com/youtube/v3/docs/search/list?hl=ja)
public extension YoutubeKit{
    
    func search(query: String? = nil,
                mine: Bool? = nil,
                relatedToVideoId: String? = nil,
                maxResults: Int? = nil,
                pageToken: String? = nil,
                channelId: String? = nil,
                option: [String: Any]? = [:],
                success: @escaping SuccessCallback<CollectionResource<SearchResource>>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["mine"] = mine
        queryItems["q"] = query
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        queryItems["relatedToVideoId"] = relatedToVideoId
        queryItems["channelId"] = channelId
        option?.forEach({queryItems[$0.key] = $0.value})
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/search")!, method: .GET, queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let searchresults = CollectionResource<SearchResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(searchresults)
        }, failure: failure)
    }
}
