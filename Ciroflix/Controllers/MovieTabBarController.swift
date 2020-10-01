//
//  TabBarController.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 29/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit

class MovieTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     let tabBarController = UITabBarController()
        let movieVC = ViewController()
        movieVC.title = "movies"

        let searchVC = SearchViewController()
        searchVC.title = "search"
        
        searchVC.view.backgroundColor = UIColorFromRGB(rgbValue: 0xe8ffff)
        self.tabBarController?.tabBar.barTintColor = UIColorFromRGB(rgbValue: 0x41aea9)
        self.tabBarController?.tabBar.tintColor = UIColorFromRGB(rgbValue: 0x41aea9)
        movieVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let controllers = [movieVC, searchVC]
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        tabBarController.modalPresentationStyle = .fullScreen
    }
        
        
    }
