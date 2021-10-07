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
    
    var currentPage: Int = 1
    var isFetching = false
    var guide: UILayoutGuide =  UILayoutGuide()
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInRow: CGFloat = 3.0
    let itemsInColumn : CGFloat = 4.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?

    override func viewDidLoad() {
        self.guide = self.view.safeAreaLayoutGuide
        
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
        self.categoryCollectionView?.register(IndicatorFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: IndicatorFooter.identifier)
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
        self.categoryCollectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.categoryCollectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.categoryCollectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.categoryCollectionViewDataSource.fetchMovies(page: self.currentPage, completion: {
            self.currentPage += 1
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionView?.reloadData()
                }
            })
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
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
                self.categoryCollectionView?.reloadData()
            }
        }
        genrePickerViewController.modalPresentationStyle = .overCurrentContext
        self.present(genrePickerViewController, animated: false, completion: nil)
    }
    
    func refreshMovies() {
        self.filterMovies()
        self.categoryCollectionView?.reloadData()
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
        
        self.categoryCollectionViewDataSource.filteredMovies = newFilteredMovies
    }
    
    func fetchFilteredMovies(currentCellIndex: Int, completion: @escaping () -> ()) {
        self.categoryCollectionViewDataSource.fetchMovies(page: self.currentPage) {
            self.filterMovies()
            let moviesOnScreen = self.categoryCollectionViewDataSource.filteredMovies.count
            if moviesOnScreen - currentCellIndex > 1 {
                self.currentPage += 1
                self.categoryCollectionViewDataSource.loadImages()
                completion()
            } else {
                self.fetchFilteredMovies(currentCellIndex: self.categoryCollectionViewDataSource.filteredMovies.count - 1, completion: completion)
                self.currentPage += 1
            }
        }
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self
        present(movieInfoViewController, animated: true)
    }
}

extension CategoryCollectionViewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = ThumbnailImageProperties.getRatio()
        
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) * CGFloat(ratio)
        let height = width * (750 / 500)
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
            self.categoryCollectionViewDataSource.footerView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: indexPath.row) {
                var paths = [IndexPath]()
                let moviesOnScreenCount = self.categoryCollectionViewDataSource.filteredMovies.count
                let hiddenMoviesCount = moviesOnScreenCount - indexPath.row
                for item in 1..<hiddenMoviesCount{
                    let indexPath = IndexPath(row: item + indexPath.row, section: 0)
                    paths.append(indexPath)
                }
                print(paths.count)
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.footerView.stopAnimating()
                    self.categoryCollectionView?.insertItems(at: paths)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageView = selectedCell?.imageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.categoryCollectionViewDataSource.filteredMovies[indexPath.row])
    }
}

extension CategoryCollectionViewViewController: InitialTransitionAnimatableContent {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let categoryCollectionViewViewController = source as? CategoryCollectionViewViewController,
                let movieInfoViewController = presented as? MovieInfoViewController,
                let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
                else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .present, initialAnimatableContent: categoryCollectionViewViewController, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let movieInfoViewController = dismissed as? MovieInfoViewController,
              let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
            else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .dismiss, initialAnimatableContent: self, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }
}


