//
//  Video.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Serializable
import Foundation

public extension YoutubeKit{
    
    /// Get informations about Video.
    /// (cf. https://developers.google.com/youtube/v3/docs/videos/list?hl=ja)
    func getVideo(id: String? = nil,
                  maxResults: Int? = nil,
                  pageToken: String? = nil,
                  success: @escaping SuccessCallback<CollectionResource<VideoResource>>, failure: @escaping FailCallback){
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet, .contentDetails,  .liveStreamingDetails, .player, .recordingDetails, .statistics, .status,  .topicDetails ]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["id"] = id
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/videos")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlists = CollectionResource<VideoResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
    /// Set rating to video.
    ///  - Parameters:
    ///     - id: video ID.
    ///     - rating: rate to set.
    /// (cf. https://developers.google.com/youtube/v3/docs/videos/rate?hl=ja)
    func setRate(id: String,
                 rating: YoutubeKit.Rate,
                 success: @escaping SuccessCallback<Void?>, failure: @escaping FailCallback){
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id
        queryItems["rating"] = rating.rawValue
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/videos/rate")!, method: .POST,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            success(nil)
        }, failure: failure)
    }
    
    /// Get rating to video.
    ///  - Parameters:
    ///     - id: video ID.
    /// (cf. https://developers.google.com/youtube/v3/docs/videos/rate?hl=ja)
    func getRate(id: String,
                 success: @escaping SuccessCallback<VideoRateReasource>, failure: @escaping FailCallback){
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/videos/getRating")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let rating = VideoRateReasource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(rating)
        }, failure: failure)
    }
}
