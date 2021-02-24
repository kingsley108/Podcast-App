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
    lazy var pagingSpinner = UIActivityIndicatorView(style: .medium)
    
    var podcast: Podcast? {
        didSet{
            guard let feedUrl = URL(string: podcast!.feedUrl) else {return}
            guard let podcastImage = podcast?.artworkUrl600 else {return}
            APIExtension.shared.parseFeed(for: feedUrl, podcastImageUrl: podcastImage) { (episodes) in
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
        var searchedEpisode = episodes[indexPath.row]
        searchedEpisode.podcastArtUrl = podcast?.artworkUrl600
        cell?.episodes = searchedEpisode
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainTabVc = UIApplication.shared.windows.first!.rootViewController as! MainTabBarController
        mainTabVc.maximizeView(episode: episodes[indexPath.row])
//        xibView.episode = episodes[indexPath.row]
//        xibView.frame = view.frame
//        keyWindow?.addSubview(xibView)
           
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        pagingSpinner.startAnimating()
        pagingSpinner.color = .purple
        pagingSpinner.hidesWhenStopped = true
        //tableView.tableHeaderView = pagingSpinner
        return pagingSpinner
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return episodes.isEmpty ? 250 : 0
    }
}
