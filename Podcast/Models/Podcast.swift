//
//  Podcast.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import Foundation
struct Podcast: Codable {
    var collectionName: String
    var artistName: String
    var feedUrl: String
    var trackCount: Int
    var artworkUrl600: String?
}
