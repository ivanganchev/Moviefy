//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, InitialTransitionAnimatableContent {
    let categoryCollectionViewLayout = CategoryCollectionViewLayout()
    var categoryType: String = ""
    var categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    var movieCategoryPath: EndPoint.MovieCategoryEndPoint?
    var genreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()
    let transitioningContentDelegateInstance = TransitioningDelegate()

    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInColumn: CGFloat = 4.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?

    override func viewDidLoad() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.categoryCollectionViewLayout.barTitle.text = self.categoryType
        self.navigationItem.titleView = self.categoryCollectionViewLayout.barTitle
        
        self.categoryCollectionViewDataSource.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionViewLayout.categoryCollectionView.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionViewLayout.categoryCollectionView.delegate = self
        
        self.categoryCollectionViewLayout.categoryCollectionView.refreshControl = UIRefreshControl()
        self.categoryCollectionViewLayout.categoryCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.categoryCollectionViewLayout.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.categoryCollectionViewLayout.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        
        self.fetchMovies()
    }
    
    override func loadView() {
        self.view = self.categoryCollectionViewLayout
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
    }

    func fetchMovies() {
        self.categoryCollectionViewDataSource.fetchMovies(completion: {
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionViewLayout.categoryCollectionView.reloadData()
                }
            })
        })
    }
    
    @objc func pullToRefresh() {
        self.categoryCollectionViewDataSource.refreshMovies(genres: self.genreChipsCollectionViewDataSource.genres, completion: {
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionViewLayout.categoryCollectionView.reloadData()
                    self.categoryCollectionViewLayout.categoryCollectionView.refreshControl?.endRefreshing()
                }
            })
        })
    }
        
    func fetchFilteredMovies(currentCellIndex: Int, completion: @escaping () -> Void) {
        self.categoryCollectionViewDataSource.fetchMovies {
            self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.genres)
            let moviesOnScreen = self.categoryCollectionViewDataSource.filteredMovies.count
            if moviesOnScreen - currentCellIndex > 1 {
                self.categoryCollectionViewDataSource.loadImages()
                completion()
            } else {
                self.fetchFilteredMovies(currentCellIndex: self.categoryCollectionViewDataSource.filteredMovies.count - 1, completion: completion)
            }
        }
    }
    
    func getIndexPathForPrefetchedMovies(currentCellIndex: Int) -> [IndexPath] {
        var paths = [IndexPath]()
        let moviesOnScreenCount = self.categoryCollectionViewDataSource.filteredMovies.count
        let hiddenMoviesCount = moviesOnScreenCount - currentCellIndex
        for item in 1..<hiddenMoviesCount {
            let indexPath = IndexPath(row: item + currentCellIndex, section: 0)
            paths.append(indexPath)
        }
        return paths
    }
    
    func presentMovieInfoViewController(with movie: Movie, index: Int) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.delegate = self
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
    
    func deleteGenreChip() {
        self.setGenreChipsViewUILayout()
        self.categoryCollectionViewLayout.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.genres)
        self.categoryCollectionViewLayout.categoryCollectionView.setContentOffset(.zero, animated: false)
        self.categoryCollectionViewLayout.categoryCollectionView.reloadData()
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.genres.isEmpty
        self.categoryCollectionViewLayout.genreChipsView.hideChipsCollectioNView(isHidden: isHidden)
    }
}

extension CategoryCollectionViewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = ImageProperties.getThumbNailImageRatio()
        
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) * CGFloat(ratio)
        let height = width * (ImageProperties.imageHeight / ImageProperties.imageWidth)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
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
        if indexPath.row == (self.categoryCollectionViewDataSource.filteredMovies.count - 1) {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: indexPath.row) {
                let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: indexPath.row)
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionViewLayout.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageView = selectedCell?.imageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.categoryCollectionViewDataSource.filteredMovies[indexPath.row], index: indexPath.row)
    }
}

extension CategoryCollectionViewViewController: GenreChipsViewDelegate {
    func presentGenrePickerViewController() {
        self.tabBarController?.tabBar.isHidden = true
        
        let selectedGenres = self.genreChipsCollectionViewDataSource.genres
        let genrePickerViewController = GenrePickerViewController()
        genrePickerViewController.selectedGenres = selectedGenres
        genrePickerViewController.delegate = self
        genrePickerViewController.modalPresentationStyle = .overCurrentContext
        self.present(genrePickerViewController, animated: false, completion: nil)
    }
}

extension CategoryCollectionViewViewController: GenrePickerViewControllerDelegate {
    func getSelectedGenre(genre: String) {
        guard genre != "" else {
            return
        }
        self.genreChipsCollectionViewDataSource.genres.append(genre)
        self.setGenreChipsViewUILayout()
        self.categoryCollectionViewLayout.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionViewLayout.categoryCollectionView.setContentOffset(.zero, animated: false)
        self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.genres)
        let filteredMovies = self.categoryCollectionViewDataSource.filteredMovies
        self.categoryCollectionViewLayout.categoryCollectionView.reloadData()
        let filteredMoviesCount = filteredMovies.count
        if filteredMoviesCount > 0 {
            let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: filteredMoviesCount - 1)
            self.categoryCollectionViewLayout.categoryCollectionView.insertItems(at: paths)
        } else {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: 0) {
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: 0)
                    self.categoryCollectionViewLayout.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
    
    func viewDismissed() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension CategoryCollectionViewViewController: MovieInfoDelegate {
    func movieInfoViewController(movieInfoViewController: MovieInfoViewController, getMovieImageData movie: Movie, completion: @escaping (Result<Data, Error>) -> Void) {
        if movie.imageData == nil {
            let index = self.categoryCollectionViewDataSource.filteredMovies.firstIndex(where: {$0 === movie})
            self.categoryCollectionViewDataSource.loadImage(index: index!, completion: {_ in
                completion(.success(self.categoryCollectionViewDataSource.filteredMovies[index!].imageData!))
            })
        } else {
            completion(.success(movie.imageData!))
        }
    }
}
