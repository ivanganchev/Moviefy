//
//  ViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import UIKit
import Foundation

class ViewController: UIViewController, MoviesTableViewButtonTapDelegate {
    var moviesCollectionView: UICollectionView?
    var moviesTableViewDataSource: MoviesTableViewDataSource?
    var moviesTableViewDelegate: MoviesTableViewDelegate?
    var moviesTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.moviesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        self.moviesTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.moviesTableViewDataSource = MoviesTableViewDataSource()
        self.moviesTableViewDelegate = MoviesTableViewDelegate()
        self.moviesTableView?.dataSource = self.moviesTableViewDataSource
        self.moviesTableView?.delegate = self.moviesTableViewDelegate
        self.moviesTableView?.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        self.moviesTableView?.showsVerticalScrollIndicator = false
        self.moviesTableView?.backgroundColor = .white
        self.view.addSubview(self.moviesTableView!)
        self.moviesTableView?.reloadData()
        self.moviesTableViewDelegate?.delegate = self
        MoviesService.loadMoviesGenreList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func switchView(path: MovieCategoryEndPoint, categoryType: String) {
        let viewController = CategoryCollectionViewViewController()
        viewController.movieCategoryPath = path
        viewController.categoryType = categoryType
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


