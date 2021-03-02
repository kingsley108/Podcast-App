//
//  UserDefaultsExtender.swift
//  Podcast
//
//  Created by Kingsley Charles on 27/02/2021.
//

import Foundation

extension UserDefaults {
    static var favouritesKey = "FavouritedPodcast"
    static var downloadKey = "DownloadPodcast"
    func getFavouritesPodcast() -> [Podcast] {
        let defaults = UserDefaults.standard
        guard let favouritedPodcast = defaults.array(forKey: UserDefaults.favouritesKey) as? [Data] else { return []}
        return favouritedPodcast.map { try! JSONDecoder().decode(Podcast.self, from: $0) }
    }
    
    func deleteFromFavourites(index: Int) {
        var favouritedPodcast = getFavouritesPodcast()
        favouritedPodcast.remove(at: index)
        let encoder = JSONEncoder()
        let data = favouritedPodcast.map { try? encoder.encode($0) }
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritesKey)
    }
    
    func downloadEpisode(for episode: Episodes) {
        var downloadedEpisodes = UserDefaults.standard.getDownloadedEpisodes()
        downloadedEpisodes.append(episode)
        let encoder = JSONEncoder()
        let data = downloadedEpisodes.map { try? encoder.encode($0) }
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
        APIExtension.shared.downloadEpisodeOffline(for: episode)
    }
    
    func getDownloadedEpisodes() -> [Episodes] {
        let defaults = UserDefaults.standard
        guard let favouritedPodcast = defaults.array(forKey: UserDefaults.downloadKey) as? [Data] else { return []}
        return favouritedPodcast.map { try! JSONDecoder().decode(Episodes.self, from: $0) }
    }
    
    func deleteFromDownloaded(index: Int) {
        var downloadedList = getDownloadedEpisodes()
        downloadedList.remove(at: index)
        let encoder = JSONEncoder()
        let data = downloadedList.map { try? encoder.encode($0) }
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
    }
    
}
