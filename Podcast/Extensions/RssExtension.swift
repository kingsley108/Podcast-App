//
//  RssExtension.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import Foundation
import FeedKit

extension Feed {
    
    func getFeedItems(imageUrl: String) -> [Episodes]{
        var episodes = [Episodes]()
        switch self {
        case .atom(_):
            break
        case let .rss(self):
            self.items?.forEach({ (feedItem) in
                var episode =  Episodes(feedItem: feedItem)
                episode.podcastArtUrl = imageUrl
                episodes.append(episode)
            })
        case .json(_):
            break
        }
        return episodes
    }
}
