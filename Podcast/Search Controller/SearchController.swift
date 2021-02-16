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
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        setUpView()
       
    }
    
    func setUpView() {
        tableView.backgroundColor = .white 
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
        podcasts = []
        tableView.reloadData()
        self.searchBar.showsCancelButton = true
        APIExtension.shared.APIRequestFetcher(searchText: textSearched) { (returnedPodcasts) in
            self.podcasts = returnedPodcasts
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
