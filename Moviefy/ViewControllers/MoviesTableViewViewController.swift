//
//  ViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import UIKit

class MoviesTableViewViewController: UIViewController, InitialTransitionAnimatableContent {
    var moviesTableView = MoviesTableView()
    var moviesTableViewDataSource = MoviesTableViewDataSource()
    var moviesTableViewDelegateInstance = MoviesTableViewDelegate()
    var transitioningContentDelegateInstance = TransitioningDelegate()
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.moviesTableView.moviesTableView.dataSource = self.moviesTableViewDataSource
        self.moviesTableView.moviesTableView.delegate = self.moviesTableViewDelegateInstance
        self.moviesTableViewDelegateInstance.delegate = self
        MoviesService.loadMoviesGenreList()
        self.moviesTableView.moviesTableView.reloadData()
    }
    
    override func loadView() {
        self.view = self.moviesTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
        self.selectedCellImageView = cell?.cellImageView
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: movie)
    }
}
