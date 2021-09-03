//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewViewController: UIViewController {
   
    var categoryCollectionView: UICollectionView?
    var categoryCollectionViewDataSource: CategoryCollectionViewDataSource?
    var movieCategoryPath: MovieCategoryEndPoint?
    
//    var movies: [Movie]? {
//        didSet {
//            DispatchQueue.main.async {
//                self.categoryCollectionView?.reloadData()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 140, height: 200)
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        self.categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
        self.categoryCollectionViewDataSource?.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView?.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        self.view.addSubview(self.categoryCollectionView!)
        self.categoryCollectionViewDataSource?.fetchMovies() {
            DispatchQueue.main.async {
                self.categoryCollectionView?.reloadData()
            }
        }
    }
}
