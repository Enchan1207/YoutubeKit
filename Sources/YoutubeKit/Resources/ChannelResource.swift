//
//  ChannelResource.swift
//
//
//  Created by EnchantCode on 2021/04/02.
//

import Foundation

public struct ChannelResource: Serializable{
    
    public let id: String?
    public struct snippet: Codable{
        public let title: String?
        public let description: String?
        public let publishedAt: String?
        public struct Thumbnail: Codable{
            public let url: URL?
            public let width: Int?
            public let height: Int?
        }
        public let thumbnails: [String: Thumbnail]?
    }
    public struct contentDetails: Codable{
        public struct relatedPlaylists: Codable{
            public let likes: String?
            public let favorites: String?
            public let uploads: String?
            public let watchHistory: String?
            public let watchLater: String?
        }
        public let googlePlusUserId: String?
    }
    public struct statistics: Codable{
        public let viewCount: UInt?
        public let commentCount: UInt?
        public let subscriberCount: UInt?
        public let hiddenSubscriberCount: Bool?
        public let videoCount: UInt?
    }
    public struct topicDetails: Codable{
        public let topicIds: [String]
    }
    public struct status: Codable{
        public let privacyStatus: String?
        public let isLinked: Bool?
    }
    public struct brandingSettings: Codable{
        public struct channel: Codable{
            public let title: String?
            public let description: String?
            public let keywords: String?
            public let defaultValueTab: String?
            public let trackingAnalyticsAccountId: String?
            public let moderateComments: Bool?
            public let showRelatedChannels: Bool?
            public let showBrowseView: Bool?
            public let featuredChannelsTitle: String?
            public let featuredChannelsUrls: [String]
            public let unsubscribedTrailer: String?
            public let profileColor: String?
        }
        public struct watch: Codable{
            public let textColor: String?
            public let backgroundColor: String?
            public let featuredPlaylistId: String?
        }
        public struct image: Codable{
            public let bannerImageUrl: String?
            public let bannerMobileImageUrl: String?
            public struct Localized: Codable{
                public let value: String?
                public let language: String?
            }
            public struct backgroundImageUrl: Codable{
                public let defaultValue: String?
                public let localized: [Localized]?
            }
            public struct largeBrandedBannerImageImapScript: Codable{
                public let defaultValue: String?
                public let localized: [Localized]?
            }
            public struct largeBrandedBannerImageUrl: Codable{
                public let defaultValue: String?
                public let localized: [Localized]?
            }
            public struct smallBrandedBannerImageImapScript: Codable{
                public let defaultValue: String?
                public let localized: [Localized]?
            }
            public struct smallBrandedBannerImageUrl: Codable{
                public let defaultValue: String?
                public let localized: [Localized]?
            }
            public let watchIconImageUrl: String?
            public let trackingImageUrl: String?
            public let bannerTabletLowImageUrl: String?
            public let bannerTabletImageUrl: String?
            public let bannerTabletHdImageUrl: String?
            public let bannerTabletExtraHdImageUrl: String?
            public let bannerMobileLowImageUrl: String?
            public let bannerMobileMediumHdImageUrl: String?
            public let bannerMobileHdImageUrl: String?
            public let bannerMobileExtraHdImageUrl: String?
            public let bannerTvImageUrl: String?
            public let bannerExternalUrl: String?
        }
        public struct Hint: Codable{
            public let property: String?
            public let value: String?
        }
        public let hints: [Hint]?
    }
    public struct invideoPromotion: Codable{
        public struct defaultValueTiming: Codable{
            public let type: String?
            public let offsetMs: UInt?
            public let durationMs: UInt?
        }
        public struct position: Codable{
            public let type: String?
            public let cornerPosition: String?
        }
        public struct Item: Codable{
            public struct ID: Codable{
                public let type: String?
                public let videoId: String?
                public let websiteUrl: String?
            }
            public struct Timing: Codable{
                public let type: String?
                public let offsetMs: UInt?
                public let durationMs: UInt?
            }
            
            public let id: ID?
            public let timing: Timing?
            public let customMessage: String?
        }
        public let items: [Item]?
    }
}
