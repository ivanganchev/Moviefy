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
    var categoryCollectionViewFlowLayoutDelegate: CategoryCollectionViewFlowLayoutDelegate?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: 130, height: 180)
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        self.categoryCollectionView?.backgroundColor = .white
        self.categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
        self.categoryCollectionViewDataSource?.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView?.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionViewFlowLayoutDelegate = CategoryCollectionViewFlowLayoutDelegate()
        self.categoryCollectionView?.delegate = self.categoryCollectionViewFlowLayoutDelegate
        self.categoryCollectionView!.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.view.addSubview(self.categoryCollectionView!)
        self.categoryCollectionViewDataSource?.fetchMovies() {
            DispatchQueue.main.async {
                self.categoryCollectionView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}


