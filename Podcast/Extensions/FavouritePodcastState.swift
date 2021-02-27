//
//  UserDefaultsExtender.swift
//  Podcast
//
//  Created by Kingsley Charles on 27/02/2021.
//

import Foundation

extension UserDefaults {
    static var favouritesKey = "FavouritedPodcast"
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
}
