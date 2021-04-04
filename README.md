# YoutubeKit

![SPM](https://img.shields.io/badge/SPM-supported-DE5C43)
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey)
[![release](https://img.shields.io/github/v/release/Enchan1207/YoutubeKit)](https://github.com/Enchan1207/YoutubeKit/releases)

## Overview

Swift framework for Youtube Data API (v3).

## Installation

Now, This framework only supports SPM (Swift Package Manager).

## Usage

**NOTE**: Before you read, please create project and generate API credentials on [Google Cloud Platform](https://console.cloud.google.com/).

### Instantiation

If you don't have any access tokens:

```swift
// Credentials
let API_KEY = "XXXXXX"
let CLIENT_ID = "XXXXXX"
let CLIENT_SECRET = "XXXXXX"

// instantiation 
let API_CREDENTIAL = YoutubeKit.APICredential(apikey: API_KEY, clientID: CLIENT_ID, clientSecret: CLIENT_SECRET)

let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: nil)
```

or if you already have access token:

```swift
// Credentials
let API_KEY = "XXXXXX"
let CLIENT_ID = "XXXXXX"
let CLIENT_SECRET = "XXXXXX"
let ACCESS_TOKEN = "XXXXXX"
let REFRESH_TOKEN = "XXXXXX"

// instantiation 
let API_CREDENTIAL = YoutubeKit.APICredential(apikey: API_KEY, clientID: CLIENT_ID, clientSecret: CLIENT_SECRET)
let ACCESS_CREDENTIAL = YoutubeKit.AccessCredential(accessToken: ACCESS_TOKEN, refreshToken: REFRESH_TOKEN, expires: Date(), grantedScopes: [.readwrite])

let youtube = YoutubeKit(apiCredential: API_CREDENTIAL, accessCredential: ACCESS_CREDENTIAL)
```

### Authorize

To authorize to access user datas in your application, set `Scope` and call `authorize`.  
(in details about *scope*, see [here](https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps#identify-access-scopes)).

**NOTE**: This authorization flow can be only used at iOS or macOS. if you want to use it at console application, you need to set `AccessCredential` when instantiation.  

for iOS:

```swift
let scope: [YoutubeKit.Scope] = [.readwrite, .forceSSL]
self.youtube.authorize(presentViewController: self, scope: scope) { (credential) in
    print(credential)
} failure: { (error) in
    print(error)
}
```

for macOS:

```swift
let scope: [YoutubeKit.Scope] = [.readwrite, .forceSSL]
self.youtube.authorize(scope: scope) { (credential) in
    print(credential)
} failure: { (error) in
    print(error)
}
```

### Call API endpoints

#### Example: [search](https://developers.google.com/youtube/v3/docs/search/list)

```swift
let query = "HIKAKIN"
self.youtube.search(query: query, maxResults: 1) { (result) in
    for item in result.items{
        print(item.serialize()!)
    }
} failure: { (_error) in
    print(error)
}
```

Response:

```json
{
    "id": {
        "kind": "youtube#channel",
        "channelId": "UCZf__ehlCEBPop-_sldpBUQ"
    },
    "snippet": {
        "thumbnails": {
            "default": {
                "url": "https:\/\/yt3.ggpht.com\/ytc\/AAUvwniFFE8I4vqAWJY-iQltV1kvYhtD-iM0wgsS6nv9lA=s88-c-k-c0xffffffff-no-rj-mo"
            },
            "high": {
                "url": "https:\/\/yt3.ggpht.com\/ytc\/AAUvwniFFE8I4vqAWJY-iQltV1kvYhtD-iM0wgsS6nv9lA=s800-c-k-c0xffffffff-no-rj-mo"
            },
            "medium": {
                "url": "https:\/\/yt3.ggpht.com\/ytc\/AAUvwniFFE8I4vqAWJY-iQltV1kvYhtD-iM0wgsS6nv9lA=s240-c-k-c0xffffffff-no-rj-mo"
            }
        },
        "channelTitle": "HikakinTV",
        "title": "HikakinTV",
        "description": "HikakinTVはヒカキンが日常の面白いものを紹介するチャンネルです。 ◇プロフィール◇ YouTubeにてHIKAKIN、HikakinTV、HikakinGames、HikakinBlogと ４つの ...",
        "channelId": "UCZf__ehlCEBPop-_sldpBUQ",
        "publishedAt": "2011-07-19T11:31:43Z"
    }
}
```


