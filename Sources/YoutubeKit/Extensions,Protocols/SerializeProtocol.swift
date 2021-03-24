//
//  SerializeProtocol.swift
//  YoutubeKit
//
//  Created by EnchantCode on 2021/03/22.
//

import Foundation

public protocol Serializable: Codable {
    func serialize() -> String?
    static func deserialize(object: String) -> Self?
}

public extension Serializable{
    func serialize() -> String?{
        guard let selializedData = try? JSONEncoder().encode(self) else {return nil}
        return String(data: selializedData, encoding: .utf8)
    }
    
    static func deserialize(object: String) -> Self?{
        let selialized = try? JSONDecoder().decode(Self.self, from: object.data(using: .utf8)!)
        return selialized
    }
}
