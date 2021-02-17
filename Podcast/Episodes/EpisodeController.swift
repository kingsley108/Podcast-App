//
//  EpisodeController.swift
//  Podcast
//
//  Created by Kingsley Charles on 17/02/2021.
//

import UIKit
import FeedKit

var episodeCell = "episodeCell"

class EpisodeController: UITableViewController {
    var episodes = [Episodes]()
    
    var podcast: Podcast? {
        didSet{
            guard let feedUrl = URL(string: podcast!.feedUrl) else {return}
            let parser = FeedParser(URL: feedUrl)
            let result = parser.parse()
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(_):
                    break
                case let .rss(feed):
                    feed.items?.forEach({ (feedItem) in
                        let episode =  Episodes(feedItem: feedItem)
                        episodes.append(episode)
                        tableView.reloadData()
                    })
                case .json(_):
                    break
                }
                
            case .failure(let error):
                print("There was an error parsing", error)
            }
        }
    }
    
    override func viewDidLoad() {
        setUpTableView()
        super.viewDidLoad()
        
    }
    
    func setUpTableView(){
        let nib = UINib(nibName: "EpisodesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: episodeCell)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCell, for: indexPath) as? EpisodesCell
        let searchedEpisode = episodes[indexPath.row]
        cell?.artworkUrl = podcast?.artworkUrl600
        cell?.episodes = searchedEpisode
        return cell!
    }
}
