//
//  File.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import Foundation
import FeedKit
struct Episodes {
    var title: String
    var pubdate: Date
    var description: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title!
        self.pubdate = feedItem.pubDate!
        self.description = feedItem.description ?? ""
    }
}
