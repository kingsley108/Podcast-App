//
//  RssExtension.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import Foundation
import FeedKit

extension Feed {
    
    func getFeedItems() -> [Episodes]{
        var episodes = [Episodes]()
        switch self {
        case .atom(_):
            break
        case let .rss(self):
            self.items?.forEach({ (feedItem) in
                let episode =  Episodes(feedItem: feedItem)
                episodes.append(episode)
            })
        case .json(_):
            break
        }
        return episodes
    }
}
