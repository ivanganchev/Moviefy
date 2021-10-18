//
//  SavedMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import Foundation
import UIKit
import RealmSwift

class SavedMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    var saveMoviesCollectionViewLayout = CategoryCollectionViewLayout()
    var savedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()
    var genreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()

    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    let transitioningContentDelegateInstance = TransitioningDelegate()

    override func viewDidLoad() {
        self.loadSavedMovies()
        
        self.saveMoviesCollectionViewLayout.barTitle.text = "My List"
        self.navigationItem.titleView = self.saveMoviesCollectionViewLayout.barTitle
        
        self.saveMoviesCollectionViewLayout.categoryCollectionView.dataSource = self.savedMoviesCollectionViewDataSource
        self.saveMoviesCollectionViewLayout.categoryCollectionView.delegate = self
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.saveMoviesCollectionViewLayout.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.saveMoviesCollectionViewLayout.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        self.loadSavedMovies()
    }
    
    override func loadView() {
        self.view = self.saveMoviesCollectionViewLayout
    }
    
    func loadSavedMovies() {
        self.savedMoviesCollectionViewDataSource.loadSavedMovies()
        self.savedMoviesCollectionViewDataSource.registerNotificationToken {changes in
            switch changes {
            case .initial:
                self.saveMoviesCollectionViewLayout.categoryCollectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.loadSavedMovies()
                self.saveMoviesCollectionViewLayout.categoryCollectionView.performBatchUpdates({
                    self.saveMoviesCollectionViewLayout.categoryCollectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    self.saveMoviesCollectionViewLayout.categoryCollectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
                    self.saveMoviesCollectionViewLayout.categoryCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let err):
                print(err)
            }
        }
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
    
    func deleteGenreChip() {
        self.setGenreChipsViewUILayout()
        self.saveMoviesCollectionViewLayout.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.genres)
        self.saveMoviesCollectionViewLayout.categoryCollectionView.reloadData()
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.genres.isEmpty
        self.saveMoviesCollectionViewLayout.genreChipsView.hideChipsCollectioNView(isHidden: isHidden)
    }
}

extension SavedMoviesViewController: GenreChipsViewDelegate {
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

extension SavedMoviesViewController: GenrePickerViewControllerDelegate {
    func getSelectedGenre(genre: String) {
        self.tabBarController?.tabBar.isHidden = false
        
        guard genre != "" else {
            return
        }
        self.genreChipsCollectionViewDataSource.genres.append(genre)
        self.setGenreChipsViewUILayout()
        self.saveMoviesCollectionViewLayout.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.genres)
        self.saveMoviesCollectionViewLayout.categoryCollectionView.reloadData()
    }
}

extension SavedMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = ThumbnailImageProperties.getRatio()
        
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) * CGFloat(ratio)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        self.selectedCellImageView = selectedCell?.imageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        let savedMovie = self.savedMoviesCollectionViewDataSource.savedMovies[indexPath.row]
        self.presentMovieInfoViewController(with: Movie(movieEntity: savedMovie, imageData: savedMovie.imageData!))
    }
}
