//
//  SavedMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import Foundation
import UIKit
import RealmSwift

class SavedMoviesViewController: UIViewController, TransitionAnimatableContent {
    var savedMoviesCollectionView: UICollectionView?
    var savedMoviesCollectionViewDataSource: SavedMoviesCollectionViewDataSource = SavedMoviesCollectionViewDataSource()
    var realm: Realm = try! Realm()
    
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?

    override func viewDidLoad() {
        let barTitle: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        barTitle.text = "My List"
        
        self.navigationItem.titleView = barTitle
        self.view.backgroundColor = .white
        
        let savedMoviesCollectionViewFlowLayout = UICollectionViewFlowLayout()
        savedMoviesCollectionViewFlowLayout.scrollDirection = .vertical
    
        self.savedMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: savedMoviesCollectionViewFlowLayout)
        self.savedMoviesCollectionView?.backgroundColor = .white
        self.savedMoviesCollectionView?.dataSource = self.savedMoviesCollectionViewDataSource
        self.savedMoviesCollectionView?.delegate = self
        self.savedMoviesCollectionView?.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.savedMoviesCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.savedMoviesCollectionView!)
        
        self.savedMoviesCollectionView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.savedMoviesCollectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.savedMoviesCollectionView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.savedMoviesCollectionView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let results = self.realm.objects(MovieEntity.self)
        
        let token = results.observe {[weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.savedMoviesCollectionView?.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.savedMoviesCollectionView?.reloadItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
            case .error(let err):
                print(err)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedMoviesCollectionViewDataSource.loadSavedMovies {
            self.savedMoviesCollectionView?.reloadData()
        }
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

extension SavedMoviesViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let savedMoviesViewController = source as? SavedMoviesViewController,
                let movieInfoViewController = presented as? MovieInfoViewController,
                let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
                else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .present, firstViewController: savedMoviesViewController, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let movieInfoViewController = dismissed as? MovieInfoViewController,
              let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
            else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .dismiss, firstViewController: self, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self
        present(movieInfoViewController, animated: true)
    }
}
