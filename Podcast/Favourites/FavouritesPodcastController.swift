//
//  CollectionViewController.swift
//  Podcast
//
//  Created by Kingsley Charles on 27/02/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavouritesPodcastController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var podcastList = UserDefaults.standard.getFavouritesPodcast()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(FavouritesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.getRootVC().viewControllers?[0].tabBarItem.badgeValue = nil
        podcastList = UserDefaults.standard.getFavouritesPodcast()
        collectionView.reloadData()
    }
    
    fileprivate func addGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(longPressGesture: UILongPressGestureRecognizer)
    {
        let point = longPressGesture.location(in: collectionView)
        guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: point) else {return}
        let alertActionCell = UIAlertController(title: "Remove Podcast", message: "", preferredStyle: .actionSheet)
        
        // Configure Remove Item Action
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.collectionView.performBatchUpdates {
                self.podcastList.remove(at: selectedIndexPath.row)
                self.collectionView.deleteItems(at: [selectedIndexPath])
                UserDefaults.standard.deleteFromFavourites(index: selectedIndexPath.row)
            }
        })
        
        // Configure Cancel Action Sheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertActionCell.addAction(deleteAction)
        alertActionCell.addAction(cancelAction)
        self.present(alertActionCell, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return podcastList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavouritesCell
        cell.podcast = podcastList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let measurements = (collectionView.frame.width - 3 * 16) / 2
        return CGSize(width: measurements, height: measurements + 46)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPodcast = podcastList[indexPath.row]
        let episodeController = EpisodeController()
        episodeController.podcast = selectedPodcast
        episodeController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(episodeController, animated: true)
        
    }
}


