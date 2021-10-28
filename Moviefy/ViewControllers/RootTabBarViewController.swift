//
//  RootTabBarViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import UIKit

struct TabBarController {
    var controller: UINavigationController
    var title: String
    var image: String
}

class RootTabBarViewController: UITabBarController {
    var tabBarControllers: [TabBarController] = []
    
    override func viewDidLoad() {
        self.tabBarControllers = [
            TabBarController(controller: UINavigationController(rootViewController: MoviesTableViewViewController()),
                             title: "Home",
                             image: "house"),
            TabBarController(controller: UINavigationController(rootViewController: SearchMoviesViewController()),
                             title: "Search",
                             image: "magnifyingglass"),
            TabBarController(controller: UINavigationController(rootViewController: SavedMoviesViewController()),
                             title: "My List",
                             image: "list.and.film")
        ]
        
        self.viewControllers = self.tabBarControllers.map {$0.controller}
        
        self.tabBarControllers.forEach { controller in
            let item = UITabBarItem(title: controller.title, image: UIImage(systemName: controller.image), tag: 0)
            controller.controller.tabBarItem = item
        }
    } 
}
