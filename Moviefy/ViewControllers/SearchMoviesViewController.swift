//
//  SearchMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import Foundation
import UIKit

class SearchMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    var searchBar: UISearchBar = UISearchBar()
    var searchMoviesTableView: UITableView = UITableView(frame: .zero, style: .plain)
    var searchMoviesTableViewDataSource: SearchMoviesTableViewDataSource = SearchMoviesTableViewDataSource()
    let transitioningContentDelegate = TransitioningDelegate()
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.setupSearchMoviesTableViewUI()
        self.setupSearchBarUI()
        self.fetchMovies(page: 1)
    }
    
    func setupSearchMoviesTableViewUI() {
        self.searchMoviesTableView.separatorStyle = .none
        self.searchMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
        self.searchMoviesTableView.delegate = self
        self.searchMoviesTableView.register(SearchMovieTableViewCell.self, forCellReuseIdentifier: SearchMovieTableViewCell.identifier)
        self.searchMoviesTableView.keyboardDismissMode = .onDrag
        
        self.view.addSubview(self.searchMoviesTableView)
        
        let guide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
             self.searchMoviesTableView.topAnchor.constraint(equalTo: guide.topAnchor),
             self.searchMoviesTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
             self.searchMoviesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
             self.searchMoviesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    func setupSearchBarUI() {
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
    }

    func fetchMovies(page: Int) {
        self.searchMoviesTableViewDataSource.fetchMovies(page: page, completion: {
            self.searchMoviesTableViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
    @objc func searchMovies() {
        guard let text = self.searchBar.text else { return }
        self.searchMoviesTableViewDataSource.searchMovies(text: text, completion: {
            self.searchMoviesTableViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
    func presentMovieInfoViewController(with movie: Movie?) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegate
        present(movieInfoViewController, animated: true)
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ThumbnailImageProperties.getSize()
        return size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! SearchMovieTableViewCell
        self.selectedCellImageView = selectedCell.movieImage
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.searchMoviesTableViewDataSource.movies[indexPath.row])
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies), object: nil)
        self.perform(#selector(self.searchMovies), with: nil, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
