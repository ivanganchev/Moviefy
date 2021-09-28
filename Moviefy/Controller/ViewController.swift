//
//  ViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import UIKit
import Foundation

class ViewController: UIViewController, MoviesTableViewButtonTapDelegate {
    var moviesTableViewDataSource: MoviesTableViewDataSource?
    var moviesTableViewDelegate: MoviesTableViewDelegate?
    var moviesTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var guide: UILayoutGuide = UILayoutGuide()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.guide = view.safeAreaLayoutGuide
        self.setLayout()
    }
    
    func switchView(path: MovieCategoryEndPoint, categoryType: String) {
        let viewController = CategoryCollectionViewViewController()
        viewController.movieCategoryPath = path
        viewController.categoryType = categoryType
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setLayout() {
        self.navigationController?.navigationBar.isHidden = true
        self.moviesTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        self.moviesTableViewDataSource = MoviesTableViewDataSource()
        self.moviesTableViewDelegate = MoviesTableViewDelegate()
        self.moviesTableView.dataSource = self.moviesTableViewDataSource
        self.moviesTableView.delegate = self.moviesTableViewDelegate
        self.moviesTableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        self.moviesTableView.showsVerticalScrollIndicator = false
        self.moviesTableView.backgroundColor = .white
        self.moviesTableView.refreshControl = UIRefreshControl()
        self.moviesTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.view.addSubview(self.moviesTableView)
        self.moviesTableView.reloadData()
        self.moviesTableViewDelegate?.delegate = self
        MoviesService.loadMoviesGenreList()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {(_) in
            self.setLayout()
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func pullToRefresh() {
        self.moviesTableView.reloadData()
        self.moviesTableView.refreshControl?.endRefreshing()
    }
}


