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
        let savedMoviesViewController = UINavigationController(rootViewController: SavedMoviesViewController())
        
        viewControllerMovies.title = "Home"
        searchMoviesViewController.title = "Search"
        savedMoviesViewController.title = "My List"
        
        self.viewControllers = [viewControllerMovies, searchMoviesViewController, savedMoviesViewController]
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["house", "magnifyingglass", "list.and.film"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }        
    }
}
