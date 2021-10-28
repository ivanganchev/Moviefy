//
//  SavedMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import UIKit
import RealmSwift

class SavedMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    var saveMoviesCollectionView = CategoryCollectionView()
    var savedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()
    var genreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()

    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    let transitioningContentDelegateInstance = TransitioningDelegate()

    override func viewDidLoad() {
        self.loadSavedMovies()
        
        self.saveMoviesCollectionView.barTitle.text = "My List"
        self.navigationItem.titleView = self.saveMoviesCollectionView.barTitle
        
        self.saveMoviesCollectionView.categoryCollectionView.dataSource = self.savedMoviesCollectionViewDataSource
        self.saveMoviesCollectionView.categoryCollectionView.delegate = self
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.saveMoviesCollectionView.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.saveMoviesCollectionView.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        self.loadSavedMovies()
    }
    
    override func loadView() {
        self.view = self.saveMoviesCollectionView
    }
    
    func loadSavedMovies() {
        self.savedMoviesCollectionViewDataSource.loadSavedMovies()
        self.savedMoviesCollectionViewDataSource.registerNotificationToken { changes in
            switch changes {
            case .initial:
                self.saveMoviesCollectionView.categoryCollectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.loadSavedMovies()
                self.saveMoviesCollectionView.categoryCollectionView.performBatchUpdates({
                    self.saveMoviesCollectionView.categoryCollectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    self.saveMoviesCollectionView.categoryCollectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
                    self.saveMoviesCollectionView.categoryCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
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
        self.saveMoviesCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        self.saveMoviesCollectionView.categoryCollectionView.reloadData()
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.getAllSelectedGenres().isEmpty
        self.saveMoviesCollectionView.genreChipsView.hideChipsCollectioNView(isHidden: isHidden)
    }
}

extension SavedMoviesViewController: GenreChipsViewDelegate {
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

extension SavedMoviesViewController: GenrePickerViewControllerDelegate {
    func genrePickerViewController(genrePickerViewController: GenrePickerViewController, genre: String) {
        guard genre != "" else {
            return
        }
        self.genreChipsCollectionViewDataSource.addSelectedGenre(genre: genre)
        self.setGenreChipsViewUILayout()
        self.saveMoviesCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        self.saveMoviesCollectionView.categoryCollectionView.reloadData()
    }
    
    func viewDismissed(genrePickerViewController: GenrePickerViewController) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension SavedMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = ImageProperties.getThumbNailImageRatio()
        
        let width = (collectionView.bounds.width - self.interItemSpacing - self.interItemSpacing) * CGFloat(ratio)
        let height = width * (ImageProperties.imageHeight / ImageProperties.imageWidth)
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
        guard let savedMovie = self.savedMoviesCollectionViewDataSource.getSavedFilteredMovieAt(index: indexPath.row) else {
            return
        }
        self.presentMovieInfoViewController(with: Movie(movieEntity: savedMovie, imageData: savedMovie.getImageDataForSavedMovie()!))
    }
}
