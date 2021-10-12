//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//
import UIKit
import RealmSwift

class MovieInfoViewController: UIViewController, PresentedTransitionAnimatableContent {
    var movieImageView: UIImageView {
        self.movieInfoViewControllerLayout.movieImageView
    }
    var movieInfoViewControllerLayout = MovieInfoViewControllerLayout(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var movie: Movie?
    var genres: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieInfoViewControllerLayout.closeButton.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.movieInfoViewControllerLayout.movieTitle.text = self.movie?.movieResponse.title
        self.movieInfoViewControllerLayout.movieOverview.text = self.movie?.movieResponse.overview
        self.movieInfoViewControllerLayout.movieDateReleased.text = self.movie?.movieResponse.releaseDate
        self.movieInfoViewControllerLayout.setGenres(genres: self.getMovieGenres())
        self.movieInfoViewControllerLayout.setHeart(movie: self.movie!)
        self.movieInfoViewControllerLayout.setMovieImage(movie: self.movie!)
    }
    
    override func loadView() {
        self.view = self.movieInfoViewControllerLayout
    }
    override func viewDidLayoutSubviews() {
        self.movieInfoViewControllerLayout.gradient.frame = CGRect(origin: .zero, size: CGSize(width: self.movieInfoViewControllerLayout.topPartView.bounds.width, height: 100))
    }
    
    @objc func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func heartButtonTap() {
        guard let movie = self.movie else {
            return
        }
        
        let realm = try? Realm()
        
        if movie.isSaved, let movieEntity = realm?.object(ofType: MovieEntity.self, forPrimaryKey: movie.id) {
            try? realm?.write({
                realm?.delete(movieEntity)
                try? realm?.commitWrite()
            })
            self.movie?.id = nil
        } else {
            let movieEntity = MovieEntity(movie: movie)
            self.movie?.id = movieEntity.id
            try? realm?.write({
                realm?.add(movieEntity, update: .all)
                realm?.create(MovieEntity.self)
            })
        }
        
        self.movieInfoViewControllerLayout.setHeart(movie: self.movie!)
    }
    
    func getMovieGenres() -> String {
        let genres = MoviesService.genres
        
        let arrayOfGenres: [String] = self.movie?.movieResponse.genreIds?.compactMap({ id in
            return genres?[id]
        }) ?? []
        
        let joined = arrayOfGenres.joined(separator: ", ")
        
        return joined
    }
}
