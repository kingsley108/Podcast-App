//
//  SearchController.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import UIKit
import Alamofire

var cellId = "SearchCell"
class SearchController: UITableViewController, UISearchBarDelegate {
    var podcasts = [Podcast]()
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search Podcast"
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentPodcast = podcasts[indexPath.row]
        cell.textLabel?.numberOfLines = -1
        cell.textLabel?.text = "\(currentPodcast.collectionName) " + "\n" + "\(currentPodcast.artistName)"
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
    
    // MARK: - SearchBar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        self.searchBar.showsCancelButton = true
        let parameters = ["term": textSearched, "media": "podcast"]
        let url = "https://itunes.apple.com/search?"
        AF.request(url, method: .get, parameters: parameters).validate().response { (response) in
            guard let data = response.data else {return}
            self.parseData(data)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func parseData(_ data: Data) {
        let decoder = JSONDecoder()
        if let json = try? decoder.decode(searchResult.self, from: data ) {
            self.podcasts = json.results ?? []
            tableView.reloadData()
        }
    }
}
