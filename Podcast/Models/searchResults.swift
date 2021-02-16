//
//  searchResults.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import Foundation
struct searchResult: Decodable {
    var resultCount: Int?
    var results: [Podcast]?
}
