//
//  APIExtenson.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import Foundation
import Alamofire

class APIExtension {
    
    static let shared = APIExtension()
    var results: [Podcast]?
     func APIRequestFetcher(searchText textSearched: String, completion:([Podcast]) -> ()) {
        
        let parameters = ["term": textSearched, "media": "podcast"]
        let url = "https://itunes.apple.com/search?"
        AF.request(url, method: .get, parameters: parameters).validate().response { (response) in
            guard let data = response.data else {return}
            self.parseData(data)
        }
        completion(results ?? [Podcast]())
    }
    
    fileprivate func parseData(_ data: Data)  {
        let decoder = JSONDecoder()
        if let json = try? decoder.decode(searchResult.self, from: data ) {
            self.results = json.results
        }
    }
    
}

