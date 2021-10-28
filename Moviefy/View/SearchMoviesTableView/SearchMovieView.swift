//
//  SearchMovieTableViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import UIKit

class SearchMovieView: UIView {
    var searchBar: UISearchBar = UISearchBar()
    var searchMoviesTableView = UITableView(frame: .zero, style: .plain)
    var recentSearchesTableView = UITableView(frame: .zero, style: .plain)
    var emptyTableViewText = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSearchBarUI()
        self.setupSearchMoviesTableView()
        self.setupRecentSearchesTableView()
        self.setConstraints()
        self.setEmptyTableViewText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchMoviesTableView() {
        self.searchMoviesTableView.separatorStyle = .none
        self.searchMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.searchMoviesTableView.register(SearchMoviesTableViewCell.self, forCellReuseIdentifier: SearchMoviesTableViewCell.identifier)
        self.searchMoviesTableView.keyboardDismissMode = .onDrag
    }
    
    func setupRecentSearchesTableView() {
        self.recentSearchesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.recentSearchesTableView.register(RecentSearchSuggestionsTableViewCell.self, forCellReuseIdentifier: RecentSearchSuggestionsTableViewCell.identifier)
        self.recentSearchesTableView.isHidden = true
    }
    
    func setupSearchBarUI() {
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.sizeToFit()
    }
    
    func setEmptyTableViewText() {
        self.emptyTableViewText.translatesAutoresizingMaskIntoConstraints = false
        self.emptyTableViewText.text = "No movies found"
        self.emptyTableViewText.font = UIFont(name: "Helvetica", size: 16)
        self.emptyTableViewText.textAlignment = .center
        self.emptyTableViewText.isHidden = true
    }

    func setConstraints() {
        self.addSubview(self.searchMoviesTableView)
        self.addSubview(self.recentSearchesTableView)
        self.addSubview(self.emptyTableViewText)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
             self.searchMoviesTableView.topAnchor.constraint(equalTo: guide.topAnchor),
             self.searchMoviesTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
             self.searchMoviesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
             self.searchMoviesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
             self.recentSearchesTableView.topAnchor.constraint(equalTo: guide.topAnchor),
             self.recentSearchesTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
             self.recentSearchesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
             self.recentSearchesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
             self.emptyTableViewText.topAnchor.constraint(equalTo: guide.topAnchor),
             self.emptyTableViewText.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
             self.emptyTableViewText.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
             self.emptyTableViewText.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    func setSearchMoviesTableViewBackground(isEmpty: Bool) {        
        self.searchMoviesTableView.isHidden = isEmpty
        self.emptyTableViewText.isHidden = !isEmpty
    }
    
    func setSearchMoviesLayout(isSuggesting: Bool) {
        self.recentSearchesTableView.isHidden = !isSuggesting
        self.searchMoviesTableView.isHidden = isSuggesting
    }
}
