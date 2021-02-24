//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var maximizeConstraint: NSLayoutConstraint?
    private var minimizeConstraint : NSLayoutConstraint?
    
    let playerViewReference = playerDetailsView.loadNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        setUpPlayerDetails()
    }
    
    func maximizeView(episode: Episodes?) {
        minimizeConstraint?.isActive = false
        maximizeConstraint?.isActive = true
        maximizeConstraint?.constant = 0
        guard let selectedEpisode = episode else {return}
        playerViewReference.episode = selectedEpisode
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 100)
        }
    }
    
    func minimizeView() {
        maximizeConstraint?.isActive = false
        maximizeConstraint?.constant = view.frame.size.height
        minimizeConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
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
        minimizeConstraint = playerViewReference.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizeConstraint?.isActive = true
        playerViewReference.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
