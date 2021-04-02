//
//  Comments.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

/// endpoint callers about Comments (https://developers.google.com/youtube/v3/docs/comments)
public extension YoutubeKit{
    
    /// Get comments in specified thread.
    /// (cf. https://developers.google.com/youtube/v3/docs/comments/list?hl=ja)
    func getComment(id: [String]? = nil,
                    parentID: String? = nil,
                    maxResults: Int? = nil,
                    pageToken: String? = nil,
                    textFormat: YoutubeKit.TextFormat,
                    success: @escaping SuccessCallback<CollectionResource<CommentResource>>, failure: @escaping FailCallback){
        // バリデーション
        if id == nil && parentID == nil {
            failure(APIError.filterError("No filter selected."))
        }
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["id"] = id?.joined(separator: ",")
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        queryItems["textFormat"] = textFormat.rawValue
        queryItems["parentId"] = parentID
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/comments")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlists = CollectionResource<CommentResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize comment items"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
    
    
    /// Insert comments in specified thread.
    /// (cf. https://developers.google.com/youtube/v3/docs/comments/insert?hl=ja)
    func insertComment(new: PlaylistItemResource,
                       success: @escaping SuccessCallback<CommentResource>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/comments")!, method: .POST, requestHeader: requestHeader, requestBody: new.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlistItem = CommentResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize comment item"))
                return
            }
            success(playlistItem)
        }, failure: failure)
    }
    
    /// Update comments in specified thread.
    /// (cf. https://developers.google.com/youtube/v3/docs/comments/update?hl=ja)
    func updateComment(new: PlaylistItemResource,
                       success: @escaping SuccessCallback<CommentResource>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        
        // ヘッダ,リクエストボディ設定
        let requestHeader:[String: String] = [
            "Content-Type": "application/json"
        ]
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/comments")!, method: .PUT, requestHeader: requestHeader, requestBody: new.serialize()!.data(using: .utf8), queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            guard let playlistItem = CommentResource.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize comment item"))
                return
            }
            success(playlistItem)
        }, failure: failure)
    }
    
    /// Mark comment as spam.
    /// (cf. https://developers.google.com/youtube/v3/docs/comments/markAsSpam?hl=ja)
    func markCommentAsSpam(id: [String],
                           success: @escaping SuccessCallback<Void?>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id.joined(separator: ",")
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/comments/markAsSpam")!, method: .POST, queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            success(nil)
        }, failure: failure)
    }
    
    /// Delete comment as spam.
    /// (cf. https://developers.google.com/youtube/v3/docs/comments/delete?hl=ja)
    func deleteComment(id: String,
                           success: @escaping SuccessCallback<Void?>, failure: @escaping FailCallback){
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        queryItems["id"] = id
        
        // configに値を設定してリクエスト
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/comments")!, method: .DELETE, queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, success: { (response) in
            success(nil)
        }, failure: failure)
    }
}
