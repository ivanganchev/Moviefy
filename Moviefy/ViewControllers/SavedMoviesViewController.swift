//
//  SavedMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import UIKit
import RealmSwift

class SavedMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    var savedMoviesCollectionView = CategoryCollectionView()
    var savedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()
    var genreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()

    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    let transitioningContentDelegateInstance = TransitioningDelegate()

    override func viewDidLoad() {
        self.savedMoviesCollectionView.barTitle.text = "My List"
        self.navigationItem.titleView = self.savedMoviesCollectionView.barTitle
        
        self.savedMoviesCollectionView.categoryCollectionView.dataSource = self.savedMoviesCollectionViewDataSource
        self.savedMoviesCollectionView.categoryCollectionView.delegate = self
        
        self.genreChipsCollectionViewDataSource.deleteAction = self.deleteGenreChip
        
        self.savedMoviesCollectionView.genreChipsView.genreChipsCollectionView.dataSource = self.genreChipsCollectionViewDataSource
        self.savedMoviesCollectionView.genreChipsView.delegate = self
        
        self.setGenreChipsViewUILayout()
        self.loadSavedMovies()
    }
    
    override func loadView() {
        self.view = self.savedMoviesCollectionView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedMoviesCollectionView.categoryCollectionView.reloadData()
    }
    
    func loadSavedMovies() {
        self.savedMoviesCollectionViewDataSource.loadSavedMovies()
        self.savedMoviesCollectionViewDataSource.registerNotificationToken {changes in
            switch changes {
            case .initial:
                self.savedMoviesCollectionView.categoryCollectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.loadSavedMovies()
                self.savedMoviesCollectionView.categoryCollectionView.performBatchUpdates({
                    self.savedMoviesCollectionView.categoryCollectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    self.savedMoviesCollectionView.categoryCollectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
                    self.savedMoviesCollectionView.categoryCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                }, completion: nil)
            case .error(let err):
                print(err)
            }
            let isEmpty = self.savedMoviesCollectionViewDataSource.getSavedFilteredMovies().isEmpty
            self.savedMoviesCollectionView.setLayoutBackgroundView(isEmpty: isEmpty)
            self.savedMoviesCollectionView.genreChipsView.isHidden = isEmpty
        }
    }

    func deleteGenreChip() {
        self.setGenreChipsViewUILayout()
        self.savedMoviesCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        self.savedMoviesCollectionView.categoryCollectionView.reloadData()
    }
    
    func setGenreChipsViewUILayout() {
        let isHidden = self.genreChipsCollectionViewDataSource.getAllSelectedGenres().isEmpty
        self.savedMoviesCollectionView.genreChipsView.hideChipsCollectionView(isHidden: isHidden)
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
        self.savedMoviesCollectionView.genreChipsView.genreChipsCollectionView.reloadData()
        self.savedMoviesCollectionViewDataSource.filterMovies(genres: self.genreChipsCollectionViewDataSource.getAllSelectedGenres())
        self.savedMoviesCollectionView.categoryCollectionView.reloadData()
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
        self.selectedCellImageView = selectedCell?.cellImageView
        self.selectedCellImageViewSnapshot = selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        
        guard let savedMovie = self.savedMoviesCollectionViewDataSource.getSavedFilteredMovie(at: indexPath.row) else {
            return
        }
        
        guard let image = self.savedMoviesCollectionViewDataSource.getImageForSavedMovie(at: indexPath.row) else {
            return
        }
        
        let movieInfoViewController = ViewControllerPresenter.configMovieInfoViewController(movie: Movie(movieEntity: savedMovie), movieImage: image)
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
}
