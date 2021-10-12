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
    var savedMoviesCollectionView: UICollectionView = {
        let savedMoviesCollectionViewFlowLayout = UICollectionViewFlowLayout()
        savedMoviesCollectionViewFlowLayout.scrollDirection = .vertical
    
        return UICollectionView(frame: .zero, collectionViewLayout: savedMoviesCollectionViewFlowLayout)
    }()
    
    var savedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    let transitioningContentDelegateInstance = TransitioningDelegate()

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.setBarTitle()
        self.setSavedMoviesCollectionView()
        self.setConstraints()
        self.loadSavedMovies()
    }
    
    func setBarTitle() {
        let barTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        barTitle.text = "My List"
        self.navigationItem.titleView = barTitle
    }
    
    func setSavedMoviesCollectionView() {
        self.savedMoviesCollectionView.backgroundColor = .white
        self.savedMoviesCollectionView.dataSource = self.savedMoviesCollectionViewDataSource
        self.savedMoviesCollectionView.delegate = self
        self.savedMoviesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.savedMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        self.view.addSubview(self.savedMoviesCollectionView)
        
        NSLayoutConstraint.activate([
            self.savedMoviesCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.savedMoviesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.savedMoviesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.savedMoviesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadSavedMovies() {
        self.savedMoviesCollectionViewDataSource.loadSavedMovies {changes in
            switch changes {
            case .initial:
                self.savedMoviesCollectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.savedMoviesCollectionView.performBatchUpdates({
                    self.savedMoviesCollectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    self.savedMoviesCollectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
                    self.savedMoviesCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
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
