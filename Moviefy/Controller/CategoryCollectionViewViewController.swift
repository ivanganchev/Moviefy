//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, UISearchResultsUpdating {
   
    var categoryCollectionView: UICollectionView?
    var categoryType: String?
    var categoryCollectionViewDataSource: CategoryCollectionViewDataSource?
    var movieCategoryPath: MovieCategoryEndPoint?
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var currentPage:Int = 1
    var isFetching = false
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInRow: CGFloat = 3.0
    let itemsInColumn : CGFloat = 4.0
    
    var selectedCell: CategoryCollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let barTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        barTitle.text = self.categoryType
        
        self.navigationItem.titleView = barTitle
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        self.categoryCollectionView?.backgroundColor = .white
        
        self.categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
        self.categoryCollectionViewDataSource?.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView?.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView?.prefetchDataSource = self.categoryCollectionViewDataSource
        
        self.categoryCollectionView?.delegate = self
        
        self.categoryCollectionView!.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        
        self.view.addSubview(self.categoryCollectionView!)
        
        for n in 1...3 {
            self.categoryCollectionViewDataSource?.fetchMovies(page: self.currentPage, completion: {
                self.currentPage += 1
                self.categoryCollectionViewDataSource?.loadImages(completion: {
                    DispatchQueue.main.async {
                        self.categoryCollectionView?.reloadData()
                    }
                })
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension CategoryCollectionViewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let movie = self.categoryCollectionViewDataSource?.getLoadedImage()
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) / self.itemsInRow
//        guard let imageData = movie?.imageData, let image: UIImage = UIImage(data: imageData) else {
//            return CGSize(width: collectionView.bounds.width / itemsInRow - self.interItemSpacing, height: collectionView.bounds.height / itemsInColumn)
//        }
//        let height = width * (image.size.height / image.size.width)
//        let height = collectionView.bounds.size.height / 4 * (collectionView.bounds.size.height / collectionView.bounds.size.width)
        let height = width * (750 / 500)
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
//        if indexPath.row == (self.categoryCollectionViewDataSource?.movies.count)! - 20 {
//            print(indexPath.row)
//            self.currentPage += 1
//            self.categoryCollectionViewDataSource?.fetchMovies(page: self.currentPage)
//            self.loadedMovies = 20
//        } else if indexPath.row == (self.categoryCollectionViewDataSource?.movies.count)! - (1 + self.loadedMovies) {
//            print(indexPath.row)
//            DispatchQueue.main.async {
//                self.categoryCollectionView?.reloadData()
//            }
//        }
//        print(indexPath.row)
//        print(self.categoryCollectionViewDataSource?.movies.count)
//        print("loaded movies -" + String(self.loadedMovies))
        
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 60 && !self.isFetching {
            self.currentPage += 1
            self.isFetching = true
            for n in 1...3 {
                self.categoryCollectionViewDataSource?.fetchMovies(page: self.currentPage, completion: {
                    self.isFetching = false
                })
            }
        }
//        print(indexPath.row)
//        print(self.categoryCollectionViewDataSource?.movies.count)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.categoryCollectionViewDataSource?.movies.count ?? 0 > self.categoryCollectionView?.numberOfItems(inSection: 0) ?? 0 {
            DispatchQueue.main.async {
                self.categoryCollectionView?.reloadData()
            }
        }
    }
    
//    func executeMultiTask() {
//        let taskGroup = DispatchGroup()
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        self.presentMovieInfoViewController(with: (self.categoryCollectionViewDataSource?.movies[indexPath.row])!)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let categoryCollectionViewViewController = source as? CategoryCollectionViewViewController,
                let movieInfoViewController = presented as? MovieInfoViewController,
                let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
                else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .present, categoryCollectionViewController: categoryCollectionViewViewController, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let movieInfoViewController = dismissed as? MovieInfoViewController,
              let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
            else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .dismiss, categoryCollectionViewController: self, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self
        present(movieInfoViewController, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


