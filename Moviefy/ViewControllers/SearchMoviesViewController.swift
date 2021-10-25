//
//  SearchMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import Foundation
import UIKit
import RealmSwift

class SearchMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    let searchMoviesTableViewLayout = SearchMovieTableViewLayout()
    
    let searchMoviesTableViewDataSource = SearchMoviesTableViewDataSource()
    let transitioningContentDelegateInstance = TransitioningDelegate()
    let recentSearchSuggestionsDataSource = RecentSearchSuggestionsDataSource()
    let recentSearchSuggestionsTableViewDelegateInstance = RecentSearchSuggestionsTableViewDelegate()
    
    var searchBarBackButton: UIBarButtonItem?
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    
    override func viewDidLoad() {
        self.view = self.searchMoviesTableViewLayout
        self.searchMoviesTableViewLayout.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
        self.searchMoviesTableViewLayout.searchMoviesTableView.delegate = self
        self.searchMoviesTableViewLayout.recentSearchesTableView.delegate = self.recentSearchSuggestionsTableViewDelegateInstance
        self.searchMoviesTableViewLayout.searchBar.delegate = self
        self.navigationItem.titleView = self.searchMoviesTableViewLayout.searchBar
        self.searchBarBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(hideSuggestionsTableView))
        self.searchMoviesTableViewLayout.recentSearchesTableView.dataSource = self.recentSearchSuggestionsDataSource
        
        self.fetchMovies(page: 1)
        self.loadSavedSuggestions()
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
    
    @objc func searchMovies(text: String) {
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
        self.searchMoviesTableViewLayout.searchMoviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func loadSavedSuggestions() {
        self.recentSearchSuggestionsDataSource.registerNotificatonToken { changes in
            switch changes {
            case .initial:
                self.searchMoviesTableViewLayout.recentSearchesTableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.recentSearchSuggestionsDataSource.loadSavedSuggestions()
                self.searchMoviesTableViewLayout.recentSearchesTableView.performBatchUpdates({
                    self.searchMoviesTableViewLayout.recentSearchesTableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.searchMoviesTableViewLayout.recentSearchesTableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.searchMoviesTableViewLayout.recentSearchesTableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                }, completion: nil)
            case .error(let err):
                print(err)
            }
        }
    }
    
    func presentMovieInfoViewController(with movie: Movie?) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
    
    @objc func showSuggestionsTableView() {
        self.navigationItem.setLeftBarButton(self.searchBarBackButton, animated: true)
        self.searchMoviesTableViewLayout.recentSearchesTableView.isHidden = false
        self.searchMoviesTableViewLayout.searchMoviesTableView.isHidden = true
        self.recentSearchSuggestionsDataSource.loadSavedSuggestions()
        self.searchMoviesTableViewLayout.recentSearchesTableView.reloadData()
    }
    
    @objc func hideSuggestionsTableView() {
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.searchMoviesTableViewLayout.recentSearchesTableView.isHidden = true
        self.searchMoviesTableViewLayout.searchMoviesTableView.isHidden = false
        self.searchMoviesTableViewLayout.searchBar.endEditing(false)
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ImageProperties.getThumbnailImageSize()
        return size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? SearchMoviesTableViewCell
        self.selectedCellImageView = selectedCell?.movieImage
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.searchMoviesTableViewDataSource.movies[indexPath.row])
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMovies), object: nil)
//        self.perform(#selector(self.searchMovies), with: nil, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.searchMoviesTableViewLayout.searchBar.text else { return }
            self.searchMovies(text: text)
        self.hideSuggestionsTableView()
        self.searchMoviesTableViewLayout.searchBar.endEditing(true)
        self.recentSearchSuggestionsDataSource.saveSearchText(text: text)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.showSuggestionsTableView()
        return true
    }
}
