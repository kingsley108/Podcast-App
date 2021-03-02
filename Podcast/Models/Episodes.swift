//
//  File.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import Foundation
import FeedKit
struct Episodes: Codable {
    var title: String
    var pubdate: Date
    var description: String
    var imageUrl: String
    var podcastArtUrl: String?
    var author: String
    var audioStream: String
    var downloadedEpisodeFilePath: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title!
        self.pubdate = feedItem.pubDate!
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
        self.author = (feedItem.iTunes?.iTunesAuthor) ?? ""
        self.audioStream = feedItem.enclosure?.attributes?.url ?? ""
    }
}
