//
//  SearchMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import Foundation
import UIKit

class SearchMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    let searchMoviesTableViewLayout = SearchMovieTableViewLayout()
    var searchMoviesTableViewDataSource: SearchMoviesTableViewDataSource = SearchMoviesTableViewDataSource()
    let transitioningContentDelegateInstance = TransitioningDelegate()
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    
    override func viewDidLoad() {
        self.view = self.searchMoviesTableViewLayout
        self.searchMoviesTableViewLayout.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
        self.searchMoviesTableViewLayout.searchMoviesTableView.delegate = self
        self.searchMoviesTableViewLayout.searchBar.delegate = self
        self.navigationItem.titleView = self.searchMoviesTableViewLayout.searchBar
        self.fetchMovies(page: 1)
    }

    func fetchMovies(page: Int) {
        self.searchMoviesTableViewDataSource.fetchMovies(page: page, completion: {
            self.searchMoviesTableViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesTableViewLayout.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
    @objc func searchMovies() {
        guard let text = self.searchMoviesTableViewLayout.searchBar.text else { return }
        
        if text != "" {
            self.searchMoviesTableViewDataSource.searchMovies(text: text, completion: {
                self.searchMoviesTableViewDataSource.loadImages(completion: {
                    DispatchQueue.main.async {
                        self.searchMoviesTableViewLayout.searchMoviesTableView.reloadData()
                    }
                })
            })
        } else {
            fetchMovies(page: 1)
        }
    }
    
    func presentMovieInfoViewController(with movie: Movie?) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
    
    func loadImageView(cell: UITableViewCell, index: Int) {
        guard let cell = cell as? SearchMoviesTableViewCell else { return }

        let movie = self.searchMoviesTableViewDataSource.movies[index]
        
        guard let path = movie.movieResponse.posterPath else {
            cell.image = UIImage(named: "not_loaded_image.jpg")
            return
        }
        
        if let cachedImage = self.searchMoviesTableViewDataSource.cache.object(forKey: NSString(string: path)) {
            cell.image = cachedImage
        } else {
            self.searchMoviesTableViewDataSource.loadImage(index: index) { image in
                DispatchQueue.main.async {
                    cell.image = image
                }
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ThumbnailImageProperties.getSize()
        return size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? SearchMoviesTableViewCell
        self.selectedCellImageView = selectedCell?.movieImage
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.searchMoviesTableViewDataSource.movies[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.loadImageView(cell: cell, index: indexPath.row)
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies), object: nil)
        self.perform(#selector(self.searchMovies), with: nil, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchMoviesTableViewLayout.searchBar.endEditing(true)
    }
}
