//
//  HTPURLResponseExt.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public extension HTTPURLResponse {
    // レスポンス中のステータスコードの種別を返す
    func typeOfStatusCode() -> HTTPURLResponse.StatusType {
        switch self.statusCode {
        case 100...199:
            return .Information
        case 200...299:
            return .Successful
        case 300...399:
            return .Redirects
        case 400...499:
            return .ClientErrors
        case 500...599:
            return .ServerErrors

        default:
            return .Invalid
        }
    }
    
    enum StatusType {
        case Information
        case Successful
        case Redirects
        case ClientErrors
        case ServerErrors

        case Invalid
    }

}
