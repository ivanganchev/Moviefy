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
        self.categoryCollectionViewDataSource.fetchMovies(completion: { result in
            switch result {
            case .success(()):
                self.categoryCollectionViewDataSource.loadImages(completion: {
                    DispatchQueue.main.async {
                        self.categoryCollectionView.categoryCollectionView.reloadData()
                    }
                })
            case.failure(_):
                if self.isCollectionViewEmpty() {
                    self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
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
        
    func fetchFilteredMovies(currentCellIndex: Int, completion: @escaping () -> Void) {
        self.categoryCollectionViewDataSource.fetchMovies { result in
            switch result {
            case .success():
                self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
                let moviesOnScreen = self.categoryCollectionViewDataSource.getFilteredMovies().count
                if moviesOnScreen - currentCellIndex > 1 {
                    self.categoryCollectionViewDataSource.loadImages()
                    completion()
                } else {
                    self.fetchFilteredMovies(currentCellIndex: self.categoryCollectionViewDataSource.getFilteredMovies().count - 1, completion: completion)
                }
            case .failure(_):
                if self.isCollectionViewEmpty() {
                    self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
                }
            }
        }
    }
    
    func getIndexPathForPrefetchedMovies(currentCellIndex: Int) -> [IndexPath] {
        var paths = [IndexPath]()
        let moviesOnScreenCount = self.categoryCollectionViewDataSource.getFilteredMovies().count
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
        self.categoryCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        if self.isCollectionViewEmpty() {
            self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
        } else {
            self.showEmptyCollectionViewTextIfNeeded(isEmpty: false)
            self.categoryCollectionView.categoryCollectionView.setContentOffset(.zero, animated: false)
            self.categoryCollectionView.categoryCollectionView.reloadData()
        }
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.getAllSelectedGenres().isEmpty
        self.categoryCollectionView.genreChipsView.hideChipsCollectioNView(isHidden: isHidden)
    }
    
    func showEmptyCollectionViewTextIfNeeded(isEmpty: Bool) {
        self.categoryCollectionView.setLayoutBackgroundView(isEmpty: isEmpty)
    }
    
    func isCollectionViewEmpty() -> Bool {
        return self.categoryCollectionViewDataSource.getFilteredMovies().isEmpty
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
        if indexPath.row == (self.categoryCollectionViewDataSource.getFilteredMovies().count - 1) {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: indexPath.row) {
                let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: indexPath.row)
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionView.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageView = selectedCell?.imageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.categoryCollectionViewDataSource.getFilteredMovieAt(index: indexPath.row), index: indexPath.row)
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
        let filteredMoviesCount = filteredMovies.count
        if filteredMoviesCount > 0 {
            let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: filteredMoviesCount - 1)
            self.categoryCollectionView.categoryCollectionView.insertItems(at: paths)
        } else {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: 0) {
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: 0)
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
        if movie.imageData == nil {
            guard let index = self.categoryCollectionViewDataSource.getFilteredMovies().firstIndex(where: {$0 === movie}) else {
                return
            }
            self.categoryCollectionViewDataSource.loadImage(index: index, completion: {_ in
                completion(.success(self.categoryCollectionViewDataSource.getFilteredMovieAt(index: index).imageData!))
            })
        } else {
            completion(.success(movie.imageData!))
        }
    }
}
