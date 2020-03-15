//
//  MainTabBarController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/13/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let viewControllers = viewControllers else {
//            return
//        }
//        
//        for viewController in viewControllers {
//            if let exploreController = viewController as? ExploreViewController {
//                exploreController.currentUser = currentUser
//            }
//        }
        
        print(currentUser?.email)
    }
}
