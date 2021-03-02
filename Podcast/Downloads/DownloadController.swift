//
//  DownloadController.swift
//  Podcast
//
//  Created by Kingsley Charles on 27/02/2021.
//

import UIKit
import Foundation

class DownloadController: UITableViewController {
    var downloadedEpisodes = UserDefaults.standard.getDownloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadNotificationRecieved(notification:)), name: Notification.Name(Variables.NotificationName), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        downloadedEpisodes = UserDefaults.standard.getDownloadedEpisodes()
        tableView.reloadData()
    }
    
    func setUpTableView(){
        let nib = UINib(nibName: "EpisodesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: episodeCell)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
    }
    
    @objc func downloadNotificationRecieved(notification: Notification) {
        
        guard let progressValue = notification.userInfo?["Progress"] as? Double else {return}
        let episodeTitle = notification.userInfo?["Episode Title"] as? String
        guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episodeTitle}) else {return}
        let currentCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodesCell
        currentCell?.progressLabel.isHidden = false
        let progressString = String(format: "%.0f", progressValue * 100)
        currentCell?.progressLabel.text = "\(progressString)%"
        if Int(progressString) == 100 {
            currentCell?.progressLabel.isHidden = true
        }
        
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(for: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    fileprivate func handleDelete(for indexPath: IndexPath) {
        self.downloadedEpisodes.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteFromDownloaded(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return downloadedEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCell, for: indexPath) as? EpisodesCell
        let searchedEpisode = downloadedEpisodes[indexPath.row]
        cell?.episodes = searchedEpisode
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainTabVc = UIApplication.shared.windows.first!.rootViewController as! MainTabBarController
        mainTabVc.maximizeView(episode: downloadedEpisodes[indexPath.row], allEpisodes: downloadedEpisodes)
        //        xibView.episode = episodes[indexPath.row]
        //        xibView.frame = view.frame
        //        keyWindow?.addSubview(xibView)
        
    }
    
    
    
}
