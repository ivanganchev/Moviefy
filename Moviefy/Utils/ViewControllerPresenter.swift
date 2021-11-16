//
//  ViewControllerPresenter.swift
//  Moviefy
//
//  Created by A-Team Intern on 11.11.21.
//

import UIKit

class ViewControllerPresenter {
    static func configMovieInfoViewController(movie: Movie, movieImage: UIImage?) -> MovieInfoViewController {
        let movieInfoViewController = MovieInfoViewController(movie: movie, image: movieImage)
        movieInfoViewController.modalPresentationStyle = .fullScreen
        return movieInfoViewController
    }
}
