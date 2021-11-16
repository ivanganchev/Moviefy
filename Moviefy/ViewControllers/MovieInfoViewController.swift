//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//
import UIKit
import RealmSwift

protocol MovieInfoDelegate: AnyObject {
    func movieInfoViewController(movieInfoViewController: MovieInfoViewController, getMovieImageData movie: Movie, completion: @escaping (UIImage) -> Void)
}

class MovieInfoViewController: UIViewController, PresentedTransitionAnimatableContent {
    var movieImageView: UIImageView {
        self.movieInfoView.movieImageView
    }
    var movieInfoView = MovieInfoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var movie: Movie
    var movieImage: UIImage?
    var genres: [String]?
    weak var delegate: MovieInfoDelegate?
    
    init(movie: Movie, image: UIImage?) {
        self.movie = movie
        self.movieImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieInfoView.closeButton.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.movieInfoView.movieTitle.text = self.movie.movieResponse.title
        self.movieInfoView.movieOverview.text = self.movie.movieResponse.overview
        self.movieInfoView.movieDateReleased.text = self.movie.movieResponse.releaseDate
        self.movieInfoView.setGenres(genres: self.getMovieGenresAsString())
        guard let primaryKey = self.movie.movieResponse.id else {
            return
        }
        self.movieInfoView.setHeart(isFilled: RealmWriteTransactionHelper.getRealmObject(primaryKey: String(primaryKey), entityType: MovieEntity.self) != nil ? true : false)
        self.movieInfoView.heartButton.addTarget(self, action: #selector(MovieInfoViewController.heartButtonTap), for: .touchUpInside)
        
        if self.movieImage == nil {
            delegate?.movieInfoViewController(movieInfoViewController: self, getMovieImageData: self.movie, completion: { image in
                self.movieInfoView.setMovieImage(image: image)
                guard let primaryKey = self.movie.movieResponse.id,
                      let movieEntity: MovieEntity = RealmWriteTransactionHelper.getRealmObject(primaryKey: String(primaryKey), entityType: MovieEntity.self)
                else {
                    return
                }
                
                guard let path = movieEntity.imageLocalPath,
                      let data = image.pngData()
                      else {
                    return
                }
                
                LocalPathFileManager.saveData(path: path, data: data)
            })
        }
        self.movieInfoView.setMovieImage(image: self.movieImage)
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
        guard let primaryKey = movie.movieResponse.id else {
            return
        }
        
        var isHeartFilled: Bool
        if let movieEntity = RealmWriteTransactionHelper.getRealmObject(primaryKey: String(primaryKey), entityType: MovieEntity.self) {
            RealmWriteTransactionHelper.realmDelete(entity: movieEntity)
            isHeartFilled = false
        } else {
            let movieEntity = MovieEntity(movie: movie)
            RealmWriteTransactionHelper.realmAdd(entity: movieEntity)
            isHeartFilled = true
            
            guard let localPath = movieEntity.imageLocalPath,
                  let data = self.movieImage?.pngData() else {
                self.movieInfoView.setHeart(isFilled: isHeartFilled)
                return
            }
            
            LocalPathFileManager.saveData(path: localPath, data: data)
        }
        self.movieInfoView.setHeart(isFilled: isHeartFilled)
    }
    
    func getMovieGenresAsString() -> String {
        self.movie.genres.joined(separator: ", ")
    }
}
