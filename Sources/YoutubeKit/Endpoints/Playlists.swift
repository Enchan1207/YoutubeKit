//
//  Playlists.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/23.
//

import Serializable
import Foundation

/// endpoint callers about Playlist (https://www.googleapis.com/youtube/v3/playlists)
public extension YoutubeKit {
    
    /// Get playlist.
    /// (cf. https://developers.google.com/youtube/v3/docs/playlists/list?hl=ja)
    /// **NOTE: In details of this function, see cf. there are descriptions only original paramerers to inject.**
    func getPlaylist(channelID: String? = nil,
                     id: String? = nil,
                     mine: Bool? = nil,
                     maxResults: Int? = nil,
                     pageToken: String? = nil,
                     success: @escaping SuccessCallback<CollectionResource<PlaylistResource>>, failure: @escaping FailCallback){
        
        // バリデーション channelID, id, mineのどれもnilならfail
        if channelID == nil && id == nil && mine == nil {
            failure(APIError.filterError("No filter selected."))
        }
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet, .status]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["channelID"] = channelID
        queryItems["id"] = id
        queryItems["mine"] = mine
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlists")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 1, success: { (response) in
            guard let playlists = CollectionResource<PlaylistResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
    /// Create new playlist.
    /// (cf.https://developers.google.com/youtube/v3/docs/playlists/insert?hl=ja)
    ///  - Parameters:
    ///     - new: playlist resource to add.
    func createPlaylist(new: PlaylistResource,
                        success: @escaping SuccessCallback<PlaylistResource>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.snippet, .status]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlists")!, method: .POST, requestHeader: requestHeader, requestBody: new.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 50, success: { (response) in
            guard let playlist = PlaylistResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlist)
        }, failure: failure)
    }
    
    /// Update existing playlist.
    /// (cf. https://developers.google.com/youtube/v3/docs/playlists/update?hl=ja)
    func updatePlaylist(target: PlaylistResource,
                        success: @escaping SuccessCallback<PlaylistResource>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.snippet, .status]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlists")!, method: .PUT, requestHeader: requestHeader, requestBody: target.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 50, success: { (response) in
            guard let playlist = PlaylistResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize: \(response)"))
                return
            }
            success(playlist)
        }, failure: failure)
    }
    
    /// Delete existing playlist.
    /// (cf. https://developers.google.com/youtube/v3/docs/playlists/delete?hl=ja)
    func deletePlaylist(id: String,
                        success: @escaping SuccessCallback<Void?>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/playlists")!, method: .DELETE, queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, quota: 50, success: { (response) in
            success(nil)
        }, failure: failure)
    }
    
}
