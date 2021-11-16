//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, InitialTransitionAnimatableContent {
    let categoryCollectionView = CategoryCollectionView()
    var categoryType: String
    var categoryCollectionViewDataSource: CategoryCollectionViewDataSource
    var movieCategoryPath: EndPoint.MovieCategoryEndPoint
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
    
    init(movieCategoryPath: EndPoint.MovieCategoryEndPoint, categoryType: String) {
        self.categoryType = categoryType
        self.movieCategoryPath = movieCategoryPath
        self.categoryCollectionViewDataSource = CategoryCollectionViewDataSource(movieCategoryPath: movieCategoryPath.rawValue)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.categoryCollectionView.barTitle.text = self.categoryType
        self.navigationItem.titleView = self.categoryCollectionView.barTitle
        
        self.categoryCollectionView.categoryCollectionView.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView.categoryCollectionView.delegate = self
        
        self.categoryCollectionView.categoryCollectionView.refreshControl = UIRefreshControl()
        self.categoryCollectionView.categoryCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.categoryCollectionView.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.categoryCollectionView.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        
        self.fetchFilteredMovies { _ in
            DispatchQueue.main.async {
                self.categoryCollectionView.categoryCollectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        self.view = self.categoryCollectionView
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
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
        
    func fetchFilteredMovies(completion: @escaping (_ filteredMoviesCount: Int) -> Void) {
        let moviesCount = self.categoryCollectionViewDataSource.getFilteredMovies().count
        let filters = self.genreChipsCollectionViewDataSource.getAllSelectedGenres()
        self.categoryCollectionViewDataSource.fetchMovies(genres: filters, completion: { result in
            switch result {
            case .success(let filteredMoviesCount):
                let res = filteredMoviesCount - moviesCount
                if res > 0 {
                    self.categoryCollectionViewDataSource.loadImages(completion: {
                        //self.categoryCollectionView.categoryCollectionView.reloadData()
                    })
                    completion(filteredMoviesCount)
                } else {
                    self.fetchFilteredMovies(completion: completion)
                }
            case .failure(let err):
                print(err)
                
                if self.isCollectionViewEmpty {
                    self.showEmptyCollectionViewTextIfNeeded(isEmpty: true)
                }
                
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionView.categoryCollectionView.collectionViewLayout.invalidateLayout()
                }
            }
        })
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
        let size = self.categoryCollectionViewDataSource.activityIndicatorView.isAnimating ? CGSize(width: UIScreen.main.bounds.width, height: 50) : CGSize(width: 0, height: 0)
        return size
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
        let currentMoviesCount = self.categoryCollectionViewDataSource.getFilteredMovies().count
        if indexPath.row == (currentMoviesCount - 1) {
            guard !self.categoryCollectionViewDataSource.isEndOfPagesReached else {
                return
            }
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.categoryCollectionView.categoryCollectionView.collectionViewLayout.invalidateLayout()
            
            self.fetchFilteredMovies { filteredMoviesCount in
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionView.categoryCollectionView.collectionViewLayout.invalidateLayout()
                    self.categoryCollectionView.categoryCollectionView.reloadData()
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
        
        let image = self.categoryCollectionViewDataSource.getMovieImage(movie: filteredMovie)
        
        let movieInfoViewController = ViewControllerPresenter.configMovieInfoViewController(movie: filteredMovie, movieImage: image)
        movieInfoViewController.delegate = self
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
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
        let filters = self.genreChipsCollectionViewDataSource.getAllSelectedGenres()
        self.categoryCollectionViewDataSource.filterMovies(genres: filters)
        let filteredMovies = self.categoryCollectionViewDataSource.getFilteredMovies()
        self.categoryCollectionView.categoryCollectionView.reloadData()
        if filteredMovies.isEmpty {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.categoryCollectionView.categoryCollectionView.layoutIfNeeded()
            self.fetchFilteredMovies { filteredMoviesCount in
                 DispatchQueue.main.async {                    
                    guard self.categoryCollectionViewDataSource.getFilteredMovies().isEmpty else {
                        return
                    }
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    let paths = IndexPathBuilder.getIndexPathForHiddenContent(oldCount: 0, newCount: self.categoryCollectionViewDataSource.getFilteredMovies().count)
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
    func movieInfoViewController(movieInfoViewController: MovieInfoViewController, getMovieImageData movie: Movie, completion: @escaping (UIImage) -> Void) {
        self.categoryCollectionViewDataSource.imageLoadingHelper.loadImage(movie: movie, completion: { image in
            completion(image)
        })
    }
}
