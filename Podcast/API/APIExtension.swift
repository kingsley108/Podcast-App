//
//  APIExtenson.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import Foundation
import Alamofire
import FeedKit

class APIExtension {
    
    static let shared = APIExtension()
    func APIRequestFetcher(searchText textSearched: String, completion: @escaping([Podcast]) -> ()) {
        var results: [Podcast]?
        let parameters = ["term": textSearched, "media": "podcast"]
        let url = "https://itunes.apple.com/search"
        AF.request(url, method: .get, parameters: parameters).response { (response) in
            
            guard let data = response.data else {return}
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(SearchResult.self, from: data ) {
                results = json.results
                completion(results ?? [Podcast]())
            }
        }
    }
    
    func parseFeed(for feedUrl: URL, completion: @escaping ([Episodes]) -> ()) {
        let parser = FeedParser(URL: feedUrl)
        let result = parser.parse()
        switch result {
        case .success(let feed):
            let episodes = feed.getFeedItems()
            completion(episodes)
        case .failure(let error):
            print("There was an error parsing", error)
        }
        
        
    }
}

