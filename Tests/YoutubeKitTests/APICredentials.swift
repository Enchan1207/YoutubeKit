//
//  APICredentials.swift
//  
//
//  Created by EnchantCode on 2021/04/02.
//

@testable import YoutubeKit
import Foundation

let API_KEY = "XXXXXX"
let CLIENT_ID = "XXXXXX"
let CLIENT_SECRET = "XXXXXX"
let ACCESS_TOKEN = "XXXXXX"
let REFRESH_TOKEN = "XXXXXX"

let API_CREDENTIAL = YoutubeKit.APICredential(apikey: API_KEY, clientID: CLIENT_ID, clientSecret: CLIENT_SECRET)
let ACCESS_CREDENTIAL = YoutubeKit.AccessCredential(accessToken: ACCESS_TOKEN, refreshToken: REFRESH_TOKEN, expires: Date(), grantedScopes: [.readwrite])
