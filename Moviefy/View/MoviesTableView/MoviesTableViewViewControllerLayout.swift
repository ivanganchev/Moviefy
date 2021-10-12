//
//  MoviesTableViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import Foundation
import UIKit

class MoviesTableViewViewControllerLayout: UIView {
    var moviesTableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setTableViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTableViewLayout() {
        self.moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.moviesTableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        self.moviesTableView.showsVerticalScrollIndicator = false
        self.moviesTableView.backgroundColor = .white
        self.moviesTableView.refreshControl = UIRefreshControl()
        self.addSubview(self.moviesTableView)
        let guide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.moviesTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.moviesTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            self.moviesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.moviesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        self.moviesTableView.reloadData()
    }
}
