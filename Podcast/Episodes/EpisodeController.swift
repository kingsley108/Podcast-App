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
            APIExtension.shared.parseFeed(for: feedUrl) { (episodes) in
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        cell?.podcastArtUrl = podcast?.artworkUrl600
        let searchedEpisode = episodes[indexPath.row]
        cell?.episodes = searchedEpisode
        return cell!
    }
}
