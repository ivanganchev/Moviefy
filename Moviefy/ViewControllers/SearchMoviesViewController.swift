//
//  SearchMoviesViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 16.09.21.
//

import UIKit
import RealmSwift

class SearchMoviesViewController: UIViewController, InitialTransitionAnimatableContent {
    let searchMoviesView = SearchMovieView()
    
    let searchMoviesTableViewDataSource = SearchMoviesTableViewDataSource()
    let transitioningContentDelegateInstance = TransitioningDelegate()
    let recentSearchSuggestionsDataSource = RecentSearchSuggestionsDataSource()
    let recentSearchSuggestionsTableViewDelegateInstance = RecentSearchSuggestionsTableViewDelegate()
    
    var searchBarBackButton: UIBarButtonItem?
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    
    override func viewDidLoad() {
        self.view = self.searchMoviesView
        self.searchMoviesView.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
        self.searchMoviesView.searchMoviesTableView.delegate = self
        self.searchMoviesView.recentSearchesTableView.delegate = self.recentSearchSuggestionsTableViewDelegateInstance
        self.recentSearchSuggestionsTableViewDelegateInstance.getSelectedSuggestionIndex = self.searchBySelectedSuggestionIndex
        self.searchMoviesView.searchBar.delegate = self
        self.navigationItem.titleView = self.searchMoviesView.searchBar
        self.searchBarBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(hideSuggestionsTableView))
        self.searchMoviesView.recentSearchesTableView.dataSource = self.recentSearchSuggestionsDataSource
        
        self.refreshMovies()
        self.loadSavedSuggestions()
    }

    func refreshMovies() {
        self.searchMoviesTableViewDataSource.resfreshMovies(completion: {
            self.searchMoviesTableViewDataSource.loadImages(completion: {
                DispatchQueue.main.async {
                    self.searchMoviesView.searchMoviesTableView.reloadData()
                }
            })
        })
    }
    
    @objc func searchMovies(text: String) {
        if text != "" {
            self.searchMoviesTableViewDataSource.searchMovies(text: text, completion: {
                if self.searchMoviesTableViewDataSource.getMovies().count > 0 {
                    self.searchMoviesTableViewDataSource.loadImages(completion: {
                        DispatchQueue.main.async {
                            self.searchMoviesView.setSearchMoviesTableViewBackground(isEmpty: false)
                            self.searchMoviesView.searchMoviesTableView.reloadData()
                            self.searchMoviesView.searchMoviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.searchMoviesView.searchMoviesTableView.reloadData()
                        self.searchMoviesView.setSearchMoviesTableViewBackground(isEmpty: true)
                    }
                }
            })
        } else {
            self.refreshMovies()
        }
    }
    
    func loadSavedSuggestions() {
        self.recentSearchSuggestionsDataSource.loadSavedSuggestions()
        self.recentSearchSuggestionsDataSource.registerNotificatonToken { changes in
            switch changes {
            case .initial:
                self.searchMoviesView.recentSearchesTableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.loadSavedSuggestions()
                self.searchMoviesView.recentSearchesTableView.performBatchUpdates({
                    self.searchMoviesView.recentSearchesTableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.searchMoviesView.recentSearchesTableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.searchMoviesView.recentSearchesTableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
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
        self.searchMoviesView.setSearchMoviesLayout(isSuggesting: true)
        self.recentSearchSuggestionsDataSource.loadSavedSuggestions()
        self.searchMoviesView.recentSearchesTableView.reloadData()
    }
    
    @objc func hideSuggestionsTableView() {
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.searchMoviesView.setSearchMoviesLayout(isSuggesting: false)
        self.searchMoviesView.setSearchMoviesTableViewBackground(isEmpty: self.shouldShowEmptyTableTextMessage())
        self.searchMoviesView.searchBar.endEditing(false)
    }
    
    func searchBySelectedSuggestionIndex(_ index: Int) {
        guard let suggestion = self.recentSearchSuggestionsDataSource.getSuggestionAt(index: index)?.suggestion else {
            return
        }
        self.searchMoviesView.searchBar.text = suggestion
        self.searchMovies(text: suggestion)
        self.hideSuggestionsTableView()
    }
    
    func shouldShowEmptyTableTextMessage() -> Bool {
        return self.searchMoviesTableViewDataSource.getMovies().isEmpty
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ImageProperties.getThumbnailImageSize()
        return size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? SearchMoviesTableViewCell
        self.selectedCellImageView = selectedCell?.movieImageView
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: self.searchMoviesTableViewDataSource.getMovieAt(index: indexPath.row))
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.searchMoviesView.searchBar.text else { return }
        self.searchMovies(text: text)
        self.hideSuggestionsTableView()
        self.searchMoviesView.searchBar.endEditing(true)
        self.recentSearchSuggestionsDataSource.saveSearchText(text: text)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchMoviesView.emptyTableViewText.isHidden = true
        self.showSuggestionsTableView()
        return true
    }
}
