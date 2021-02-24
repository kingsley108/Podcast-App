//
//  GetRootController.swift
//  Podcast
//
//  Created by Kingsley Charles on 24/02/2021.
//

import Foundation
import UIKit

extension UIApplication {
    
    func getRootVC() -> MainTabBarController {
        return UIApplication.shared.windows.first!.rootViewController as! MainTabBarController
    }
}
