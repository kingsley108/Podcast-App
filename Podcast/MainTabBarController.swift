//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var maximizeConstraint: NSLayoutConstraint?
    private var minimizeConstraint: NSLayoutConstraint?
    private var bottomnConstraint: NSLayoutConstraint?
    
    let playerViewReference = playerDetailsView.loadNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        setUpPlayerDetails()
    }
    
    func maximizeView(episode: Episodes?) {
        maximizeConstraint?.isActive = true
        maximizeConstraint?.constant = 0
        minimizeConstraint?.isActive = false
        bottomnConstraint?.constant = 0
        if let selectedEpisode = episode {
            playerViewReference.episode = selectedEpisode
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 100)
            self.playerViewReference.mainPlayerView.alpha = 1
            self.playerViewReference.miniPlayerView.alpha = 0
        }
    }
    
    func minimizeView() {
        
        maximizeConstraint?.isActive = false
        minimizeConstraint?.isActive = true
        bottomnConstraint?.constant = view.frame.height
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5 , options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerViewReference.mainPlayerView.alpha = 0
            self.playerViewReference.miniPlayerView.alpha = 1
            
        }
    }
    
    func setUpTabBar() {
        self.tabBar.tintColor = .purple
        viewControllers = [setUpNavControllers(viewController: SearchController(), image: #imageLiteral(resourceName: "search"), title: "Search"),
            setUpNavControllers(viewController: ViewController(), image: #imageLiteral(resourceName: "favorites"), title: "Favourites"),
                           setUpNavControllers(viewController: ViewController(), image: #imageLiteral(resourceName: "downloads"), title: "Downloads")]
    }
    
    
    fileprivate func setUpPlayerDetails() {
        view.insertSubview(playerViewReference, belowSubview: tabBar)
        playerViewReference.translatesAutoresizingMaskIntoConstraints = false
        maximizeConstraint = playerViewReference.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeConstraint?.isActive = true
        minimizeConstraint = playerViewReference.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomnConstraint = playerViewReference.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomnConstraint?.isActive = true
        playerViewReference.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerViewReference.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
    }
    
    
    fileprivate func setUpNavControllers(viewController: UIViewController, image: UIImage, title: String) -> UINavigationController {
        let vc = viewController
        let templateNavController = UINavigationController(rootViewController: vc)
        templateNavController.tabBarItem.image = image
        templateNavController.tabBarItem.title = title
        templateNavController.navigationBar.prefersLargeTitles = true
        templateNavController.topViewController?.title = title
        return templateNavController
    }
    
    
}
