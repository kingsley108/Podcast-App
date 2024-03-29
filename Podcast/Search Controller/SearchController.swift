//
//  SearchController.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import UIKit
import Alamofire

var cellId = "cellId"
class SearchController: UITableViewController, UISearchBarDelegate {
    var podcasts = [Podcast]()
    var timer: Timer?
    lazy var searchBar: UISearchBar = UISearchBar()
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please enter a search term"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView() {
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search Podcast"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        UIScrollView().keyboardDismissMode = .onDrag
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCell
        let searchedPodcast = podcasts[indexPath.row]
        cell.podcast = searchedPodcast
        return cell
    }
    
    // MARK: - SearchBar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
            self.tableView.reloadData()
            self.searchBar.showsCancelButton = true
            APIExtension.shared.APIRequestFetcher(searchText: textSearched) { (returnedPodcasts) in
                self.podcasts = returnedPodcasts
                self.tableView.reloadData()
            }
        })
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let noResultsLabel = self.label
        return noResultsLabel
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPodcast = podcasts[indexPath.row]
        let episodesController = EpisodeController()
        episodesController.navigationItem.title = selectedPodcast.collectionName
        episodesController.podcast = selectedPodcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count > 0 || searchBar.text!.count > 0 ? 0 : 250
    }
}
