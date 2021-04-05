//
//  PlaylistItems.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/24.
//

import Serializable
import Foundation

/// endpoint callers about Playlist items (https://www.googleapis.com/youtube/v3/playlistItems)
public extension YoutubeKit {
    /// Get playlist items.
    /// (cf. https://developers.google.com/youtube/v3/docs/playlistItems/list?hl=ja)
    /// **NOTE: In details of this function, see cf. there are descriptions only original paramerers to inject.**
    ///  - Parameters:
    func getPlaylistItem(id: [String]? = nil,
                         playlistId: String? = nil,
                         maxResults: Int? = nil,
                         pageToken: String? = nil,
                         videoId: String? = nil,
                         success: @escaping SuccessCallback<CollectionResource<PlaylistItemResource>>, failure: @escaping FailCallback){
        
        // バリデーション
        if playlistId == nil && id == nil{
            failure(APIError.filterError("No filter selected."))
        }
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet, .status, .contentDetails]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["playlistId"] = playlistId
        queryItems["id"] = id?.joined(separator: ",")
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        queryItems["videoId"] = videoId
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlists = CollectionResource<PlaylistItemResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize playlist items"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
    /// Insert new items to existing playlist.
    /// (cf.https://developers.google.com/youtube/v3/docs/playlistItems/insert?hl=ja)
    ///  - Parameters:
    ///     - new: playlist resource to add.
    func insertPlaylistItem(new: PlaylistItemResource,
                            success: @escaping SuccessCallback<PlaylistItemResource>, failure: @escaping FailCallback){
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.snippet, .contentDetails, .status]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!, method: .POST, requestHeader: requestHeader, requestBody: new.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlistItem = PlaylistItemResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize playlist item"))
                return
            }
            success(playlistItem)
        }, failure: failure)
    }
    
    /// Update existing items in playlist.
    /// (cf.https://developers.google.com/youtube/v3/docs/playlistItems/update?hl=ja)
    ///  - Parameters:
    ///     - new: playlist resource to add.
    func updatePlaylistItem(target: PlaylistItemResource,
                            success: @escaping SuccessCallback<PlaylistItemResource>, failure: @escaping FailCallback){
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.snippet, .contentDetails, .status]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!, method: .PUT, requestHeader: requestHeader, requestBody: target.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlistItem = PlaylistItemResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize playlist item"))
                return
            }
            success(playlistItem)
        }, failure: failure)
    }
    
    /// Delete existing item in playlist.
    /// (cf. https://developers.google.com/youtube/v3/docs/playlistItems/delete?hl=ja)
    func deletePlaylistItem(id: String,
                            success: @escaping SuccessCallback<Void?>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!, method: .DELETE, queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            success(nil)
        }, failure: failure)
    }
}
