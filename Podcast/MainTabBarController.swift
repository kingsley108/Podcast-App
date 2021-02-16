//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Kingsley Charles on 16/02/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        self.tabBar.tintColor = .purple
        viewControllers = [setUpNavControllers(viewController: SearchController(), image: #imageLiteral(resourceName: "search"), title: "Search"),
            setUpNavControllers(viewController: ViewController(), image: #imageLiteral(resourceName: "favorites"), title: "Favourites"),
                           setUpNavControllers(viewController: ViewController(), image: #imageLiteral(resourceName: "downloads"), title: "Downloads")]
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
