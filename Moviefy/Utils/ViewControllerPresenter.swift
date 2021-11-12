//
//  ViewControllerPresenter.swift
//  Moviefy
//
//  Created by A-Team Intern on 11.11.21.
//

import UIKit

class ViewControllerPresenter {
    static func presentMovieInfoViewController(movie: Movie, completion: (_ movieInfoViewController: MovieInfoViewController) -> Void) {
        let movieInfoViewController = MovieInfoViewController()
        movieInfoViewController.movie = movie
        movieInfoViewController.modalPresentationStyle = .fullScreen
        completion(movieInfoViewController)
    }
}
