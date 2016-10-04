//
//  RootTabBarController.swift
//  Clapperboard
//
//  Created by Steve Johnson on 04/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    let leaderboardViewController = LeaderboardViewController()
    let nominationsViewController = NominationsViewController()
    let searchViewController = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        
        view.tintColor = UIColor.red
        
        leaderboardViewController.title = "Leaderboard"
        leaderboardViewController.tabBarItem.image = UIImage(named: "tab_leaderboard")
        
        nominationsViewController.title = "Nominations"
        nominationsViewController.tabBarItem.image = UIImage(named: "tab_nominations")
        
        searchViewController.title = "Search"
        searchViewController.tabBarItem.image = UIImage(named: "tab_search")
        
        self.viewControllers = [leaderboardViewController, nominationsViewController, searchViewController]
    }
}
