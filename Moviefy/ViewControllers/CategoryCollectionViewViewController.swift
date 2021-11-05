//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, InitialTransitionAnimatableContent {
    let categoryCollectionView = CategoryCollectionView()
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
    
    var isCollectionViewEmpty: Bool {
        return self.categoryCollectionViewDataSource.getFilteredMovies().isEmpty
    }

    override func viewDidLoad() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.categoryCollectionView.barTitle.text = self.categoryType
        self.navigationItem.titleView = self.categoryCollectionView.barTitle
        
        self.categoryCollectionViewDataSource.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView.categoryCollectionView.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView.categoryCollectionView.delegate = self
        
        self.categoryCollectionView.categoryCollectionView.refreshControl = UIRefreshControl()
        self.categoryCollectionView.categoryCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.categoryCollectionView.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.categoryCollectionView.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        
        self.fetchMovies()
    }
    
    override func loadView() {
        self.view = self.categoryCollectionView
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
    }

    func fetchMovies() {
        self.categoryCollectionViewDataSource.fetchMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres(), completion: { result in
            switch result {
            case .success:
                self.categoryCollectionViewDataSource.loadImages(completion: {
                    DispatchQueue.main.async {
                        self.categoryCollectionView.categoryCollectionView.reloadData()
                    }
                })
            case .failure:
                if self.isCollectionViewEmpty {
                    self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
                } else {
                    DispatchQueue.main.async {
                        self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                        self.categoryCollectionViewDataSource.isEndOfPagesReached = true
                    }
                }
            }

        })
    }
    
    @objc func pullToRefresh() {
        self.categoryCollectionViewDataSource.refreshMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres(), completion: {
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionView.categoryCollectionView.reloadData()
                    self.categoryCollectionView.categoryCollectionView.refreshControl?.endRefreshing()
                }
            })
        })
    }
        
    func fetchFilteredMovies(currentCellIndex: Int, completion: @escaping (_ currentMoviesFilteredCount: Int) -> Void) {
        self.categoryCollectionViewDataSource.movieService.dataTask?.cancel()
        self.categoryCollectionViewDataSource.movieService.dataTask = nil
        
        self.categoryCollectionViewDataSource.fetchMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres(), completion: { result in
            switch result {
            case .success:
                let moviesOnScreen = self.categoryCollectionViewDataSource.getFilteredMovies().count
                // moviesOnScreen - currentCellIndex must be bigger than 1, cuz if there are 7 movies after filtering and current index is 5, this means that you need to show one more movie at index 6
                let res = moviesOnScreen - currentCellIndex
                if res > 1 {
                    self.categoryCollectionViewDataSource.loadImages(completion: {
                        print(res)
                        print(moviesOnScreen)
                        print(currentCellIndex)
                        completion(moviesOnScreen)
                    })
                } else {
                    let cellIndex: Int
                    
                    if moviesOnScreen > 1 {
                        cellIndex = moviesOnScreen - 1
                    } else {
                        cellIndex = 0
                    }
                    self.fetchFilteredMovies(currentCellIndex: cellIndex, completion: completion)
                }
            case .failure(let err):
                print(err)
                if self.isCollectionViewEmpty {
                    self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
                } else {
                    DispatchQueue.main.async {
                        self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                        self.categoryCollectionViewDataSource.isEndOfPagesReached = true
                    }
                }
            }
        })
    }
    
    func getIndexPathForPrefetchedMovies(currentCellIndex: Int, currentFilteredMoviesCount: Int) -> [IndexPath] {
        var paths = [IndexPath]()
        let moviesOnScreenCount = self.categoryCollectionViewDataSource.getFilteredMovies().count
        let hiddenMoviesCount: Int
        if moviesOnScreenCount == currentFilteredMoviesCount {
            hiddenMoviesCount = moviesOnScreenCount - currentCellIndex
        } else {
            return paths
        }
        
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
        self.categoryCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        if self.isCollectionViewEmpty && self.categoryCollectionViewDataSource.isEndOfPagesReached {
            self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
        } else {
            self.showEmptyCollectionViewTextIfNeeded(isEmpty: false)
            self.categoryCollectionView.categoryCollectionView.setContentOffset(.zero, animated: false)
            self.categoryCollectionView.categoryCollectionView.reloadData()
        }
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.getAllSelectedGenres().isEmpty
        self.categoryCollectionView.genreChipsView.hideChipsCollectionView(isHidden: isHidden)
    }
    
    func showEmptyCollectionViewTextIfNeeded(isEmpty: Bool) {
        self.categoryCollectionView.setLayoutBackgroundView(isEmpty: isEmpty)
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
        // self.categoryCollectionViewDataSource.activityIndicatorView.isA
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
        if indexPath.row == (self.categoryCollectionViewDataSource.getFilteredMovies().count - 1) {
            
            guard indexPath.row < self.categoryCollectionViewDataSource.getFilteredMovies().count else {
                return
            }
            
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: indexPath.row) { count in
                let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: indexPath.row, currentFilteredMoviesCount: count)
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionView.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageView = selectedCell?.cellImageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        
        guard let filteredMovie = self.categoryCollectionViewDataSource.getFilteredMovie(at: indexPath.row) else {
            return
        }
        
        self.presentMovieInfoViewController(with: filteredMovie, index: indexPath.row)
    }
}

extension CategoryCollectionViewViewController: GenreChipsViewDelegate {    
    func didSelectAddGenre(genreChipsView: GenreChipsView) {
        self.tabBarController?.tabBar.isHidden = true
        
        let selectedGenres = self.genreChipsCollectionViewDataSource.getAllSelectedGenres()
        let genrePickerViewController = GenrePickerViewController()
        genrePickerViewController.selectedGenres = selectedGenres
        genrePickerViewController.delegate = self
        genrePickerViewController.modalPresentationStyle = .overCurrentContext
        self.present(genrePickerViewController, animated: false, completion: nil)
    }
}

extension CategoryCollectionViewViewController: GenrePickerViewControllerDelegate {
    func genrePickerViewController(genrePickerViewController: GenrePickerViewController, genre: String) {
        guard genre != "" else {
            return
        }
        self.categoryCollectionView.setLayoutBackgroundView(isEmpty: false)
        self.genreChipsCollectionViewDataSource.addSelectedGenre(genre: genre)
        self.setGenreChipsViewUILayout()
        self.categoryCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionView.categoryCollectionView.setContentOffset(.zero, animated: false)
        self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        let filteredMovies = self.categoryCollectionViewDataSource.getFilteredMovies()
        self.categoryCollectionView.categoryCollectionView.reloadData()
        if filteredMovies.isEmpty {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: 0) { count in
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: 0, currentFilteredMoviesCount: count)
                    self.categoryCollectionView.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
    
    func viewDismissed(genrePickerViewController: GenrePickerViewController) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension CategoryCollectionViewViewController: MovieInfoDelegate {
    func movieInfoViewController(movieInfoViewController: MovieInfoViewController, getMovieImageData movie: Movie, completion: @escaping (Result<Data, Error>) -> Void) {
        self.categoryCollectionViewDataSource.imageLoadingHelper.reloadImage(movie: movie, completion: { imageData in
            completion(.success(imageData))
        })
    }
}
