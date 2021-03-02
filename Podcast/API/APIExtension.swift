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
    
    func parseFeed(for feedUrl: URL, podcastImageUrl: String, completion: @escaping ([Episodes]) -> ()) {
        let parser = FeedParser(URL: feedUrl)
        let result = parser.parse()
        switch result {
        case .success(let feed):
            let episodes = feed.getFeedItems(imageUrl: podcastImageUrl)
            completion(episodes)
        case .failure(let error):
            print("There was an error parsing", error)
        }
        
        
    }
    
    func downloadEpisodeOffline(for episode: Episodes) {
        var downloadedEpisodes = UserDefaults.standard.getDownloadedEpisodes()
        guard let index = (downloadedEpisodes.firstIndex{$0.description == episode.description}) else {return}
        let destination = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.audioStream, to:destination)
                .downloadProgress { (progress) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Variables.NotificationName), object: nil, userInfo: ["Episode Title": episode.title, "Progress": progress])
                }
                .response { (response) in
                    downloadedEpisodes[index].downloadedEpisodeFilePath = response.fileURL?.absoluteString
                    let encoder = JSONEncoder()
                    let data = downloadedEpisodes.map { try? encoder.encode($0) }
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
                        
            }
    }
}

