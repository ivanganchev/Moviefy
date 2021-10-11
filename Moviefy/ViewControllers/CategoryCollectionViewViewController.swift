//
//  CategoryCollectionViewViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewViewController: UIViewController, UIViewControllerTransitioningDelegate, InitialTransitionAnimatableContent {
    let categoryCollectionView: UICollectionView = {
        let categoryCollectionViewLayout = UICollectionViewFlowLayout()
        categoryCollectionViewLayout.scrollDirection = .vertical
        
        return UICollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout)
    }()
    var categoryType: String = ""
    var categoryCollectionViewDataSource = CategoryCollectionViewDataSource()
    var movieCategoryPath: EndPoint.MovieCategoryEndPoint?
    var genreChipsView: GenreChipsView = GenreChipsView(frame: .zero)
    var genreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()
    let transitioningContentDelegate = TransitioningDelegate()

    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInColumn : CGFloat = 4.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?

    override func viewDidLoad() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
    
        self.setBarTitle()
        self.setCategoryCollectionView()
        self.setGenreChipsView()
        self.setConstraints()
        
        self.fetchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setBarTitle() {
        let barTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        barTitle.text = self.categoryType
        self.navigationItem.titleView = barTitle
    }
    
    func setCategoryCollectionView() {
        self.categoryCollectionView.backgroundColor = .white
        self.categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.categoryCollectionViewDataSource.movieCategoryPath = self.movieCategoryPath?.rawValue
        self.categoryCollectionView.dataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView.prefetchDataSource = self.categoryCollectionViewDataSource
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.categoryCollectionView.register(IndicatorFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: IndicatorFooter.identifier)
        self.categoryCollectionView.refreshControl = UIRefreshControl()
        self.categoryCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.view.addSubview(self.categoryCollectionView)
    }
    
    func setGenreChipsView() {
        let chipsGenreCollectionViewLayout = UICollectionViewFlowLayout()
        chipsGenreCollectionViewLayout.scrollDirection = .horizontal
        
        self.genreChipsView.translatesAutoresizingMaskIntoConstraints = false
        self.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.genreChipsCollectionViewDataSource.delegate = self.genreChipsView
        self.genreChipsView.delegate = self
        
        self.view.addSubview(self.genreChipsView)
    }
    
    func setConstraints() {
        let guide = self.view.safeAreaLayoutGuide
    
        NSLayoutConstraint.activate([
            self.categoryCollectionView.topAnchor.constraint(equalTo: self.genreChipsView.bottomAnchor),
            self.categoryCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.categoryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.genreChipsView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.genreChipsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.genreChipsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.genreChipsView.heightAnchor.constraint(equalToConstant: 50),
            self.genreChipsView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }

    func fetchMovies() {
        self.categoryCollectionViewDataSource.fetchMovies(completion: {
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            })
        })
    }
    
    @objc func pullToRefresh() {
        self.categoryCollectionViewDataSource.refreshMovies(completion: {
            self.categoryCollectionViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                    self.categoryCollectionView.refreshControl?.endRefreshing()
                }
            })
        })
    }
        
    func fetchFilteredMovies(currentCellIndex: Int, completion: @escaping () -> ()) {
        self.categoryCollectionViewDataSource.fetchMovies() {
            self.categoryCollectionViewDataSource.filterMovies(genres: GenreChipsCollectionViewDataSource.genres)
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
        for item in 1..<hiddenMoviesCount{
            let indexPath = IndexPath(row: item + currentCellIndex, section: 0)
            paths.append(indexPath)
        }
        return paths
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegate
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
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: indexPath.row) {
                let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: indexPath.row)
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    self.categoryCollectionView.insertItems(at: paths)
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

extension CategoryCollectionViewViewController: GenreChipsViewDelegate {
    func presentGenrePickerViewController() {
        self.tabBarController?.tabBar.isHidden = true
        let selectedGenres = GenreChipsCollectionViewDataSource.genres
        let genrePickerViewController = GenrePickerViewController()
        genrePickerViewController.selectedGenres = selectedGenres
        genrePickerViewController.delegate = self
        genrePickerViewController.modalPresentationStyle = .overCurrentContext
        self.present(genrePickerViewController, animated: false, completion: nil)
    }
    
    func didSelectAddGenres() {
        let selectedGenres: [String] = GenreChipsCollectionViewDataSource.genres
        self.categoryCollectionViewDataSource.filterMovies(genres: selectedGenres)
        self.categoryCollectionView.reloadData()
    }
}

extension CategoryCollectionViewViewController: GenrePickerViewControllerDelegate {
    func getSelectedGenre(genre: String) {
        self.tabBarController?.tabBar.isHidden = false
        
        guard genre != "" else {
            return
        }
        GenreChipsCollectionViewDataSource.genres.append(genre)
        self.genreChipsView.genreChipsCollectionView.reloadData()
        self.categoryCollectionViewDataSource.filterMovies(genres: GenreChipsCollectionViewDataSource.genres)
        let filteredMovies = self.categoryCollectionViewDataSource.filteredMovies
        let filteredMoviesCount = filteredMovies.count
        if filteredMoviesCount > 0 {
            let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: filteredMoviesCount - 1)
            self.categoryCollectionView.insertItems(at: paths)
        } else {
            self.categoryCollectionViewDataSource.activityIndicatorView.startAnimating()
            self.fetchFilteredMovies(currentCellIndex: 0) {
                DispatchQueue.main.async {
                    self.categoryCollectionViewDataSource.activityIndicatorView.stopAnimating()
                    let paths = self.getIndexPathForPrefetchedMovies(currentCellIndex: 0)
                    self.categoryCollectionView.insertItems(at: paths)
                }
            }
        }
    }
}
