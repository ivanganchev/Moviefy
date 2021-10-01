//
//  SavedMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import Foundation
import UIKit

class SavedMoviesViewController: UIViewController {
    var savedMoviesCollectionView: UICollectionView?
    var savedMoviesCollectionViewDataSource: SavedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        
    }
}
