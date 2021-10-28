//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//
import UIKit
import RealmSwift

protocol MovieInfoDelegate: AnyObject {
    func movieInfoViewController(movieInfoViewController: MovieInfoViewController, getMovieImageData movie: Movie, completion: @escaping (Result<Data, Error>) -> Void)
}

class MovieInfoViewController: UIViewController, PresentedTransitionAnimatableContent {
    var movieImageView: UIImageView {
        self.movieInfoView.movieImageView
    }
    var movieInfoView = MovieInfoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var movie: Movie?
    var genres: [String]?
    var isHeartFilled: Bool = false
    weak var delegate: MovieInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieInfoView.closeButton.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.movieInfoView.movieTitle.text = self.movie?.movieResponse.title
        self.movieInfoView.movieOverview.text = self.movie?.movieResponse.overview
        self.movieInfoView.movieDateReleased.text = self.movie?.movieResponse.releaseDate
        self.movieInfoView.setGenres(genres: self.getMovieGenresAsString())
        guard let primaryKey = self.movie?.movieResponse.id else {
            return
        }
        self.isHeartFilled = RealmWriteTransactionHelper.getRealmObject(primaryKey: String(primaryKey), entityType: MovieEntity.self) != nil ? true : false
        self.movieInfoView.setHeart(isFilled: self.isHeartFilled)
        self.movieInfoView.heartButton.addTarget(self, action: #selector(MovieInfoViewController.heartButtonTap), for: .touchUpInside)
        
        if movie?.imageData == nil {
            delegate?.movieInfoViewController(movieInfoViewController: self, getMovieImageData: self.movie!, completion: { result in
                switch result {
                case .success(let data):
                    self.movie?.imageData = data
                    self.movieInfoView.setMovieImage(movie: self.movie!)
                case .failure(let err):
                    print(err)
                }
            })
        }
        self.movieInfoView.setMovieImage(movie: self.movie!)
    }
    
    override func loadView() {
        self.view = self.movieInfoView
    }
    override func viewDidLayoutSubviews() {
        self.movieInfoView.gradient.frame = CGRect(origin: .zero, size: CGSize(width: self.movieInfoView.topPartView.bounds.width, height: 100))
    }
    
    @objc func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func heartButtonTap() {
        guard let movie = self.movie else {
            return
        }
    
        guard let primaryKey = self.movie?.movieResponse.id else {
            return
        }
        
        if let movieEntity = RealmWriteTransactionHelper.getRealmObject(primaryKey: String(primaryKey), entityType: MovieEntity.self) {
            RealmWriteTransactionHelper.realmDelete(entity: movieEntity)
            self.isHeartFilled = false
        } else {
            let movieEntity = MovieEntity(movie: movie)
            RealmWriteTransactionHelper.realmAdd(entity: movieEntity)
            self.isHeartFilled = true
        }
        self.movieInfoView.setHeart(isFilled: self.isHeartFilled)
    }
    
    func getMovieGenresAsString() -> String {
        guard let joined = self.movie?.genres?.joined(separator: ", ") else {
            return ""
        }
        
        return joined
    }
}
