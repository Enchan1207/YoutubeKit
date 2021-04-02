//
//  CommentThreads.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

public extension YoutubeKit{
    /// Get comment thread of specified video.
    /// (cf. https://developers.google.com/youtube/v3/docs/commentThreads/list?hl=ja)
    func getCommentThread(id: [String]? = nil,
                          channelId: String? = nil,
                          allThreadsRelatedToChannelId: String? = nil,
                          videoId: String? = nil,
                          maxResults: Int? = nil,
                          pageToken: String? = nil,
                          order: CommentThreadOrder? = nil,
                          searchTerms: String? = nil,
                          textFormat: TextFormat? = nil,
                          success: @escaping SuccessCallback<CollectionResource<CommentThreadResource>>, failure: @escaping FailCallback){
        
        // バリデーション
        if id == nil && channelId == nil && videoId == nil && allThreadsRelatedToChannelId == nil {
            failure(APIError.filterError("No filter selected."))
        }
        
        // パラメータ挿入
        var queryItems: [String: Any] = [:]
        let part: [YoutubeKit.Part] = [.id, .snippet, .replies]
        queryItems["part"] = part.map({$0.rawValue}).joined(separator: ",")
        queryItems["id"] = id?.joined(separator: ",")
        queryItems["allThreadsRelatedToChannelId"] = allThreadsRelatedToChannelId
        queryItems["videoId"] = videoId
        queryItems["maxResults"] = maxResults
        queryItems["pageToken"] = pageToken
        queryItems["order"] = order?.rawValue
        queryItems["searchTerms"] = searchTerms
        queryItems["textFormat"] = textFormat?.rawValue
        
        // configに値を設定してリクエスト アクセストークンは挿入しない
        let config = RequestConfig(url: URL(string: "https://www.googleapis.com/youtube/v3/commentThreads")!, method: .GET,  queryItems: queryItems)
        
        sendRequestWithAutoUpdate(config: config, injectToken: false, success: { (response) in
            guard let playlists = CollectionResource<CommentThreadResource>.deserialize(object: response)else {
                failure(YoutubeKit.APIError.codableError("\(#function): couldn't deserialize comment-thread items"))
                return
            }
            success(playlists)
        }, failure: failure)
    }
}
