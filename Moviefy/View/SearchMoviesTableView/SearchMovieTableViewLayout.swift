//
//  SearchMovieTableViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import Foundation
import UIKit

class SearchMovieTableViewLayout: UIView {
    var searchBar: UISearchBar = UISearchBar()
    var searchMoviesTableView: UITableView = UITableView(frame: .zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSearchBarUI()
        self.setupSearchMoviesTableViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchMoviesTableViewUI() {
        self.searchMoviesTableView.separatorStyle = .none
        self.searchMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
//        self.searchMoviesTableView.dataSource = self.searchMoviesTableViewDataSource
//        self.searchMoviesTableView.delegate = self
        self.searchMoviesTableView.register(SearchMovieTableViewCell.self, forCellReuseIdentifier: SearchMovieTableViewCell.identifier)
        self.searchMoviesTableView.keyboardDismissMode = .onDrag
        
        self.addSubview(self.searchMoviesTableView)
        
        let guide = self.safeAreaLayoutGuide
        
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
//        self.searchBar.delegate = self
//        self.navigationItem.titleView = self.searchBar
    }
}
