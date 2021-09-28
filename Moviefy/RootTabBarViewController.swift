//
//  RootTabBarViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import Foundation
import UIKit

class RootTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        
        let viewControllerMovies = UINavigationController(rootViewController: ViewController())
        let searchMoviesViewController = UINavigationController(rootViewController: SearchMoviesViewController())
        
        viewControllerMovies.title = "Home"
        searchMoviesViewController.title = "Search"
        
        self.viewControllers = [viewControllerMovies, searchMoviesViewController]
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["house", "magnifyingglass"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        

        
    }
}
