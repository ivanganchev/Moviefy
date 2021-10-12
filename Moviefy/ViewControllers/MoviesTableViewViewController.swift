//
//  ViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import UIKit
import Foundation

class MoviesTableViewViewController: UIViewController, InitialTransitionAnimatableContent {
    var moviesTableViewViewControllerLayout = MoviesTableViewViewControllerLayout()
    var moviesTableViewDataSource = MoviesTableViewDataSource()
    var moviesTableViewDelegateInstance = MoviesTableViewDelegate()
    var transitioningContentDelegateInstance = TransitioningDelegate()
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view = self.moviesTableViewViewControllerLayout
        
        self.moviesTableViewViewControllerLayout.moviesTableView.dataSource = self.moviesTableViewDataSource
        self.moviesTableViewViewControllerLayout.moviesTableView.delegate = self.moviesTableViewDelegateInstance
        self.moviesTableViewViewControllerLayout.moviesTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.moviesTableViewDelegateInstance.delegate = self
        MoviesService.loadMoviesGenreList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func pullToRefresh() {
        self.moviesTableViewViewControllerLayout.moviesTableView.reloadData()
        self.moviesTableViewViewControllerLayout.moviesTableView.refreshControl?.endRefreshing()
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
}

extension MoviesTableViewViewController: MoviesTableViewButtonTapDelegate {
    func switchView(path: EndPoint.MovieCategoryEndPoint, categoryType: String) {
        let viewController = CategoryCollectionViewViewController()
        viewController.movieCategoryPath = path
        viewController.categoryType = categoryType
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie) {
        self.selectedCellImageView = cell?.imageView
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: movie)
    }
}
