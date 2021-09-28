//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, GenreChipsViewDelegate {
   
    var categoryCollectionView: UICollectionView?
    var categoryType: String = ""
    var categoryCollectionViewDataSource: CategoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    var movieCategoryPath: MovieCategoryEndPoint?
    var genreChipsView: GenreChipsView?
    
    //var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var currentPage: Int = 1
    var isFetching = false
    var guide: UILayoutGuide =  UILayoutGuide()
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInRow: CGFloat = 3.0
    let itemsInColumn : CGFloat = 4.0
    
    var selectedCell: CategoryCollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.guide = self.view.safeAreaLayoutGuide
        
//        self.searchController.searchResultsUpdater = self
//        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let barTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        barTitle.text = self.categoryType
        
        self.navigationItem.titleView = barTitle
        
        let categoryCollectionViewLayout = UICollectionViewFlowLayout()
        categoryCollectionViewLayout.scrollDirection = .vertical
        
        self.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout)
        self.categoryCollectionView?.backgroundColor = .white
        self.categoryCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.categoryCollectionViewDataSource.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView?.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView?.prefetchDataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView?.delegate = self
        self.categoryCollectionView?.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.categoryCollectionView?.refreshControl = UIRefreshControl()
        self.categoryCollectionView?.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        let chipsGenreCollectionViewLayout = UICollectionViewFlowLayout()
        chipsGenreCollectionViewLayout.scrollDirection = .horizontal
        
        self.genreChipsView = GenreChipsView(frame: .zero)
        self.genreChipsView?.translatesAutoresizingMaskIntoConstraints = false
        self.genreChipsView?.delegate = self
        // Not sure about it
        self.view.addSubview(self.categoryCollectionView ?? UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: categoryCollectionViewLayout))
        self.view.addSubview(self.genreChipsView!)
        
        self.genreChipsView?.topAnchor.constraint(equalTo: self.guide.topAnchor).isActive = true
        self.genreChipsView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.genreChipsView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.genreChipsView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.genreChipsView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.categoryCollectionView?.topAnchor.constraint(equalTo: self.genreChipsView!.bottomAnchor).isActive = true
        self.categoryCollectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.categoryCollectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.categoryCollectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        for n in 1...3 {
            self.categoryCollectionViewDataSource.fetchMovies(page: self.currentPage, completion: {
                self.currentPage += 1
                self.categoryCollectionViewDataSource.loadImages(completion: {
                    DispatchQueue.main.async {
                        self.categoryCollectionView?.reloadData()
                    }
                })
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func pullToRefresh() {
        self.currentPage = 1
        self.categoryCollectionViewDataSource.fetchMovies(page: self.currentPage, completion: {
            self.currentPage += 1
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionView?.reloadData()
                    self.categoryCollectionView?.refreshControl?.endRefreshing()
                }
            })
        })
    }
    
    func presentGenrePickerViewController() {
        self.tabBarController?.tabBar.isHidden = true
        let genrePickerViewController = GenrePickerViewController()
        genrePickerViewController.selectedGenres = self.genreChipsView?.genreChipsCollectionViewDataSource.genres ?? []
        genrePickerViewController.onDoneBlock = {genre in
            self.tabBarController?.tabBar.isHidden = false
            if genre != "" {
                self.genreChipsView?.genreChipsCollectionViewDataSource.genres.append(genre)
                self.genreChipsView?.genreChipsCollectionView?.reloadData()
                self.filterMovies()
            }
        }
        genrePickerViewController.modalPresentationStyle = .overCurrentContext
        self.present(genrePickerViewController, animated: false, completion: nil)
    }
    
    func refreshMovies() {
        self.filterMovies()
    }
    
    func filterMovies() {
        let movies = self.categoryCollectionViewDataSource.movies
        let allGenres = MoviesService.genres
        let selectedGenres = self.genreChipsView?.genreChipsCollectionViewDataSource.genres
        var newFilteredMovies: [Movie] = movies
        
        selectedGenres?.forEach({ genre in
            var tempArr: [Movie] = []
            newFilteredMovies.forEach { movie in
                let id = allGenres?.first(where: {$0.value == genre})?.key
                if movie.movieResponse.genreIds!.contains(id!) {
                    tempArr.append(movie)
                }
            }
            newFilteredMovies = tempArr
        })
        
        self.categoryCollectionViewDataSource.filteredMovies = newFilteredMovies.count == 0 ? movies : newFilteredMovies
        self.categoryCollectionView?.reloadData()
    }
}

extension CategoryCollectionViewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let movie = self.categoryCollectionViewDataSource?.getLoadedImage()
        var ratio = 0.0
        if collectionView.bounds.width < collectionView.bounds.height {
            ratio = 0.33
        } else {
            ratio = 0.33 / 2
        }
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) * CGFloat(ratio)
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
                self.categoryCollectionViewDataSource.fetchMovies(page: self.currentPage, completion: {
                    self.isFetching = false
                })
            }
        }
//        print(indexPath.row)
//        print(self.categoryCollectionViewDataSource?.movies.count)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.categoryCollectionViewDataSource.movies.count ?? 0 > self.categoryCollectionView?.numberOfItems(inSection: 0) ?? 0 {
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
        self.selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.categoryCollectionViewDataSource.filteredMovies[indexPath.row])
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
}


