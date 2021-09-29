//
//  SearchMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import Foundation
import UIKit

class SearchMoviesViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, UIViewControllerTransitioningDelegate {
    var searchBar: UISearchBar = UISearchBar()
    var searchMoviesTableView: UITableView = UITableView(frame: .zero, style: .plain)
    var searchMoviesTableViewDataSource: SearchMoviesTableViewDataSource?
    
    var selectedCell: SearchMovieTableViewCell?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
    
        self.searchMoviesTableView.separatorStyle = .none
        self.searchMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchMoviesTableViewDataSource = SearchMoviesTableViewDataSource()
        self.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
        self.searchMoviesTableView.delegate = self
        self.searchMoviesTableView.register(SearchMovieTableViewCell.self, forCellReuseIdentifier: SearchMovieTableViewCell.identifier)
        
        self.view.addSubview(self.searchMoviesTableView)
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
        
        self.searchMoviesTableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.searchMoviesTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        self.searchMoviesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        self.searchMoviesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        self.searchMoviesTableViewDataSource?.fetchMovies(page: 1, completion: {
            self.searchMoviesTableViewDataSource?.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.searchMoviesTableView.beginUpdates()
        self.searchMoviesTableView.endUpdates()
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies), object: nil)
        self.perform(#selector(self.searchMovies), with: nil, afterDelay: 0.75)
    }
    
    @objc func searchMovies() {
        self.searchMoviesTableViewDataSource?.searchMovies(text: self.searchBar.text ?? "", completion: {
            self.searchMoviesTableViewDataSource?.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard let categoryCollectionViewViewController = source as? CategoryCollectionViewViewController,
//                let movieInfoViewController = presented as? MovieInfoViewController,
//                let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
//                else { return nil }
//
//        self.transitionAnimator = TransitionAnimator(type: .present, categoryCollectionViewController: categoryCollectionViewViewController, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
//        return self.transitionAnimator
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard let movieInfoViewController = dismissed as? MovieInfoViewController,
//              let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
//            else { return nil }
//
//        self.transitionAnimator = TransitionAnimator(type: .dismiss, categoryCollectionViewController: self, movieInfoViewController: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
//        return self.transitionAnimator
//    }
//
//    func presentMovieInfoViewController(with movie: Movie) {
//        let movieInfoViewController = MovieInfoViewController()
//        movieInfoViewController.movie = movie
//        movieInfoViewController.modalPresentationStyle = .fullScreen
//        movieInfoViewController.transitioningDelegate = self
//        present(movieInfoViewController, animated: true)
//    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ThumbnailImageProperties.getSize()
        return size.height
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentCell = tableView.cellForRow(at: indexPath) as! SearchMovieTableViewCell
//        
//        self.selectedCell = currentCell
//        self.selectedCellImageViewSnapshot = currentCell.movieImage.snapshotView(afterScreenUpdates: false)
//        self.presentMovieInfoViewController(with: (self.searchMoviesTableViewDataSource?.movies[indexPath.row])!)
//    }
}
