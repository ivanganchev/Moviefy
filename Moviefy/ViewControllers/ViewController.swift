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
    
    var selectedCellImageView: UIImageView?
    var selectedCellImageViewSnapshot: UIView?
    var transitionAnimator: TransitionAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.guide = view.safeAreaLayoutGuide
        self.setLayout()
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
    
    private func setLayout() {
        self.navigationController?.navigationBar.isHidden = true
        self.moviesTableView.frame = CGRect(origin: .zero, size: .zero)
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
        let guide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.moviesTableView.bottomAnchor.constraint(equalTo:  guide.bottomAnchor),
            self.moviesTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.moviesTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        self.moviesTableView.reloadData()
        self.moviesTableViewDelegate?.delegate = self
        MoviesService.loadMoviesGenreList()
    }
    
    @objc func pullToRefresh() {
        self.moviesTableView.reloadData()
        self.moviesTableView.refreshControl?.endRefreshing()
    }
    
    func setClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie) {
        self.selectedCellImageView = cell?.imageView
        self.selectedCellImageViewSnapshot = self.selectedCellImageView?.snapshotView(afterScreenUpdates: true)
        self.presentMovieInfoViewController(with: movie)
    }
}

extension ViewController: InitialTransitionAnimatableContent, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let searchMoviesViewController = source as? ViewController,
                let movieInfoViewController = presented as? MovieInfoViewController,
                let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
                else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .present, initialAnimatableContent: searchMoviesViewController, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let movieInfoViewController = dismissed as? MovieInfoViewController,
              let selectedCellImageViewSnapshot = self.selectedCellImageViewSnapshot
            else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .dismiss, initialAnimatableContent: self, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }
    
    func presentMovieInfoViewController(with movie: Movie) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        movieInfoViewController.transitioningDelegate = self
        present(movieInfoViewController, animated: true)
    }
}


