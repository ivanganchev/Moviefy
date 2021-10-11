//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//
import UIKit
import RealmSwift

class MovieInfoViewController: UIViewController, PresentedTransitionAnimatableContent {
    var movie: Movie?
    var genres: [String]?
    var movieInfoScrollView = UIScrollView()
    var movieTitle = UILabel()
    var movieImageView = UIImageView()
    var shadowView = UIView()
    var gradient = CAGradientLayer()
    var closeButton = UIButton()
    var heartButton = UIButton()
    var movieOverview = UILabel()
    var movieGenres = UILabel()
    var movieDateReleased = UILabel()
    var movieOverviewLabel = UILabel()
    var containerView = UIView()
    var topPartView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
                
        self.setMovieInfoScrollView()
        self.setMovieTitle()
        self.setMovieImageView()
        self.setShadowView()
        self.setCloseButton()
        self.setHeartButton()
        self.setMovieOverview()
        self.setMovieGenres()
        self.setMovieDateReleased()
        self.setMovieOverviewLabel()
        self.setContainerView()
        self.setTopPartView()
        self.setConstraints()
        self.setHeart()
    }
    
    func setMovieInfoScrollView() {
        self.movieInfoScrollView = UIScrollView()
        self.movieInfoScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.movieInfoScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setMovieTitle() {
        self.movieTitle = UILabel()
        self.movieTitle.numberOfLines = 0
        self.movieTitle.lineBreakMode = .byWordWrapping
        self.movieTitle.font = UIFont(name: "Helvetica-Bold", size: 28)
        self.movieTitle.translatesAutoresizingMaskIntoConstraints = false
        self.movieTitle.text = self.movie?.movieResponse.title
    }
    
    func setMovieImageView() {
        if let imageData = self.movie?.imageData {
            self.movieImageView.image = UIImage(data: imageData)
        }
        self.movieImageView.contentMode = .scaleAspectFit
        self.movieImageView.clipsToBounds = true
        self.movieImageView.layer.cornerRadius = 20
        self.movieImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.movieImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setShadowView() {
        self.shadowView.frame = CGRect(origin: .zero, size: .zero)
        self.gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        self.gradient.locations = [0.0, 0.4, 1.0]
        self.gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        self.gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.shadowView.layer.addSublayer(gradient)
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setCloseButton() {
        self.closeButton = UIButton(type: .custom)
        self.closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeButton.imageView?.contentMode = .scaleAspectFit
        self.closeButton.contentHorizontalAlignment = .fill
        self.closeButton.contentVerticalAlignment = .fill
        self.closeButton.tintColor = .white
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.closeButton.isUserInteractionEnabled = true
    }
    
    func setHeartButton() {
        self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.heartButton.imageView?.contentMode = .scaleAspectFit
        self.heartButton.contentHorizontalAlignment = .fill
        self.heartButton.contentVerticalAlignment = .fill
        self.heartButton.tintColor = .white
        self.heartButton.translatesAutoresizingMaskIntoConstraints = false
        self.heartButton.addTarget(self, action: #selector(MovieInfoViewController.heartButtonTap), for: .touchUpInside)
        self.heartButton.isUserInteractionEnabled = true
    }
    
    func setMovieOverview() {
        self.movieOverview = UILabel()
        self.movieOverview.numberOfLines = 0
        self.movieOverview.lineBreakMode = .byWordWrapping
        self.movieOverview.font = UIFont(name: "Helvetica", size: 18)
        self.movieOverview.translatesAutoresizingMaskIntoConstraints = false
        self.movieOverview.tintColor = .lightGray
        self.movieOverview.alpha = 0.9
        self.movieOverview.text = self.movie?.movieResponse.overview
    }
    
    func setMovieGenres() {
        self.movieGenres = UILabel()
        self.movieGenres.numberOfLines = 0
        self.movieGenres.font = UIFont(name: "Helvetica", size: 14)
        self.movieGenres.translatesAutoresizingMaskIntoConstraints = false
        self.movieGenres.tintColor = .lightGray
        self.movieGenres.alpha = 0.7
        self.setGenres()
    }
    
    func setMovieDateReleased() {
        self.movieDateReleased = UILabel()
        self.movieDateReleased.numberOfLines = 0
        self.movieDateReleased.font = UIFont(name: "Helvetica", size: 14)
        self.movieDateReleased.translatesAutoresizingMaskIntoConstraints = false
        self.movieDateReleased.tintColor = .lightGray
        self.movieDateReleased.alpha = 0.7
        self.movieDateReleased.text = self.movie?.movieResponse.releaseDate
    }
    
    func setMovieOverviewLabel() {
        self.movieOverviewLabel = UILabel()
        self.movieOverviewLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        self.movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.movieOverviewLabel.text = "Description"
    }
    
    func setContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTopPartView() {
        self.topPartView = UIView()
        self.topPartView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        let guide = self.view.safeAreaLayoutGuide
        
        self.shadowView.addSubview(self.closeButton)
        self.shadowView.addSubview(self.heartButton)
        
        NSLayoutConstraint.activate([
            self.closeButton.centerYAnchor.constraint(equalTo: self.shadowView.centerYAnchor, constant: 10),
            self.closeButton.leadingAnchor.constraint(equalTo: self.shadowView.leadingAnchor, constant: 20),
            self.closeButton.widthAnchor.constraint(equalToConstant: 25),
            self.closeButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.heartButton.centerYAnchor.constraint(equalTo: self.shadowView.centerYAnchor, constant: 10),
            self.heartButton.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: -20),
            self.heartButton.widthAnchor.constraint(equalToConstant: 30),
            self.heartButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        self.topPartView.addSubview(self.movieImageView)
        self.topPartView.addSubview(self.shadowView)
        
        NSLayoutConstraint.activate([
            self.movieImageView.topAnchor.constraint(equalTo: self.topPartView.topAnchor),
            self.movieImageView.leadingAnchor.constraint(equalTo: self.topPartView.leadingAnchor),
            self.movieImageView.trailingAnchor.constraint(equalTo: self.topPartView.trailingAnchor),
             self.movieImageView.heightAnchor.constraint(equalTo: self.movieImageView.widthAnchor, multiplier: self.movieImageView.image!.size.height / self.movieImageView.image!.size.width, constant: 0),
            self.shadowView.widthAnchor.constraint(equalTo: self.topPartView.widthAnchor),
            self.shadowView.heightAnchor.constraint(equalToConstant: 100),
            self.shadowView.topAnchor.constraint(equalTo: self.topPartView.topAnchor)
        ])
    
        self.containerView.addSubview(self.topPartView)
        self.containerView.addSubview(self.movieTitle)
        self.containerView.addSubview(self.movieGenres)
        self.containerView.addSubview(self.movieDateReleased)
        self.containerView.addSubview(self.movieOverviewLabel)
        self.containerView.addSubview(self.movieOverview)
        
        NSLayoutConstraint.activate([
            self.topPartView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.topPartView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.topPartView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            self.topPartView.heightAnchor.constraint(equalTo: self.movieImageView.heightAnchor),
            
            self.movieTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.movieTitle.topAnchor.constraint(equalTo: self.topPartView.bottomAnchor, constant: 15),
            self.movieTitle.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
            
            self.movieGenres.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.movieGenres.topAnchor.constraint(equalTo: self.movieTitle.bottomAnchor, constant: 5),
            self.movieGenres.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
            
            self.movieDateReleased.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.movieDateReleased.topAnchor.constraint(equalTo: self.movieGenres.bottomAnchor, constant: 5),
            self.movieDateReleased.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
            
            self.movieOverviewLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.movieOverviewLabel.topAnchor.constraint(equalTo: self.movieDateReleased.bottomAnchor, constant: 15),
            self.movieOverviewLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
            
            self.movieOverview.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.movieOverview.topAnchor.constraint(equalTo: self.movieOverviewLabel.bottomAnchor, constant: 5),
            self.movieOverview.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            self.movieOverview.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10)
        ])

        self.movieInfoScrollView.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.movieInfoScrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.movieInfoScrollView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.movieInfoScrollView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.movieInfoScrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.movieInfoScrollView.widthAnchor)
        ])
        
        self.view.addSubview(self.movieInfoScrollView)

        NSLayoutConstraint.activate([
            self.movieInfoScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.movieInfoScrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            self.movieInfoScrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.movieInfoScrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            self.movieInfoScrollView.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        self.gradient.frame = CGRect(origin: .zero, size: CGSize(width: self.topPartView.bounds.width, height: 100))
    }
    
    @objc func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func heartButtonTap() {
        guard let movie = self.movie else {
            return
        }
        
        let realm = try! Realm()
        
        if movie.isSaved, let movieEntity = realm.object(ofType: MovieEntity.self, forPrimaryKey: movie.id){
            try! realm.write({
                realm.delete(movieEntity)
                try! realm.commitWrite()
            })
            self.movie?.id = nil
        } else {
            let movieEntity = MovieEntity(movie: movie)
            self.movie?.id = movieEntity.id
            try! realm.write({
                realm.add(movieEntity, update: .all)
                realm.create(MovieEntity.self)
            })
        }
        
        self.setHeart()
    }
    
    func setHeart() {
        let imageName = self.movie?.id != nil ? "suit.heart.fill" : "heart"
        self.heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        self.heartButton.tintColor = self.movie?.id != nil ? .red : .white
    }
    
    private func setGenres() {
        let genres = MoviesService.genres
        
        let arrayOfGenres: [String] = self.movie?.movieResponse.genreIds?.compactMap({ id in
            return genres?[id]
        }) ?? []
        
        let joined = arrayOfGenres.joined(separator: ", ")
        
        self.movieGenres.text = joined
    }
}
