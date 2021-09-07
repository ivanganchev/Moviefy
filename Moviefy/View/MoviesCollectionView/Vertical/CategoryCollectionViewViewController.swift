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
    var movies:[Movie]?
    var currentPage:Int = 1
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInRow: CGFloat = 3.0
    let itemsInColumn : CGFloat = 4.0
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        self.categoryCollectionView?.backgroundColor = .white
        
        self.categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
        self.categoryCollectionViewDataSource?.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView?.dataSource = self.categoryCollectionViewDataSource
        
        self.categoryCollectionView?.delegate = self
        
        self.categoryCollectionView!.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        self.view.addSubview(self.categoryCollectionView!)
        
        self.categoryCollectionViewDataSource?.fetchMovies(page: self.currentPage, completion: { result in
            switch result {
                case .success(let movies):
                    self.movies = movies
                    DispatchQueue.main.async {
                        self.categoryCollectionView?.reloadData()
                    }
                case .failure(let err):
                    print(err)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension CategoryCollectionViewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / self.itemsInRow - self.interItemSpacing - self.itemsInRow
        let height = collectionView.bounds.height / self.itemsInColumn
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.movies!.count - 3{
            self.currentPage += 1
            self.categoryCollectionViewDataSource?.fetchMovies(page: self.currentPage, completion: { result in
                switch result {
                    case .success(let movies):
                        self.movies?.append(contentsOf: movies)
                        DispatchQueue.main.async {
                            self.categoryCollectionView?.reloadData()
                        }
                    case .failure(let err):
                        print(err)
                }
            })
        }
    }
}


