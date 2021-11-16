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
}

extension MoviesTableViewViewController: MoviesTableViewButtonTapDelegate {
    func switchView(path: EndPoint.MovieCategoryEndPoint, movieCategoryType: String) {
        let viewController = CategoryCollectionViewViewController(movieCategoryPath: path, categoryType: movieCategoryType)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapCollectionViewCell(moviesTableViewCell: MoviesTableViewCell, cell: ThumbnailCell?, movie: Movie) {
        self.selectedCellImageView = cell?.cellImageView
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        
        let image = moviesTableViewCell.moviesCollectionViewDataSource.getMovieImage(movie: movie)
        
        let movieInfoViewController = ViewControllerPresenter.configMovieInfoViewController(movie: movie, movieImage: image)
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self.transitioningContentDelegateInstance
        present(movieInfoViewController, animated: true)
    }
}
