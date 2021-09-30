//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//

import UIKit

class MovieInfoViewController: UIViewController {

    var movie: Movie?
    var genres: [String]?
    var movieInfoScrollView: UIScrollView = UIScrollView()
    var movieTitle: UILabel = UILabel()
    var movieImage: UIImageView = UIImageView()
    var shadowView: UIView = UIView()
    var closeButton: UIButton = UIButton()
    var movieOverview: UILabel = UILabel()
    var movieGenres: UILabel = UILabel()
    var movieDateReleased: UILabel = UILabel()
    var movieOverviewLabel: UILabel = UILabel()
    var containerView: UIView = UIView()
    var topPartView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.movieInfoScrollView = UIScrollView()
        self.movieInfoScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.movieInfoScrollView.contentInsetAdjustmentBehavior = .never
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageData = self.movie?.imageData {
            self.movieImage.image = UIImage(data: imageData)
        }
        self.movieImage.contentMode = .scaleAspectFit
        self.movieImage.clipsToBounds = true
        self.movieImage.layer.cornerRadius = 20
        self.movieImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.movieImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.shadowView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        let gradient = CAGradientLayer()
        gradient.frame = self.shadowView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.locations = [0.0, 0.4, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.shadowView.layer.addSublayer(gradient)
        
        self.closeButton = UIButton(type: .custom)
        self.closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeButton.imageView?.contentMode = .scaleAspectFit
        self.closeButton.contentHorizontalAlignment = .fill
        self.closeButton.contentVerticalAlignment = .fill
        self.closeButton.tintColor = .white
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.closeButton.isUserInteractionEnabled = true
        
        self.shadowView.addSubview(self.closeButton)
        
        self.closeButton.centerYAnchor.constraint(equalTo: self.shadowView.centerYAnchor, constant: 10).isActive = true
        self.closeButton.leadingAnchor.constraint(equalTo: self.shadowView.leadingAnchor, constant: 20).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.topPartView = UIView()
        self.topPartView.translatesAutoresizingMaskIntoConstraints = false
        self.topPartView.addSubview(self.movieImage)
        self.topPartView.addSubview(self.shadowView)
        self.movieImage.topAnchor.constraint(equalTo: self.topPartView.topAnchor).isActive = true
        self.movieImage.leadingAnchor.constraint(equalTo: self.topPartView.leadingAnchor).isActive = true
        self.movieImage.trailingAnchor.constraint(equalTo: self.topPartView.trailingAnchor).isActive = true
//        Ето тук ще изчезнат !, ако премахнем по-нагоре 
        self.movieImage.heightAnchor.constraint(equalTo: self.movieImage.widthAnchor, multiplier: self.movieImage.image!.size.height / self.movieImage.image!.size.width, constant: 0).isActive = true
        self.shadowView.leadingAnchor.constraint(equalTo: self.topPartView.leadingAnchor).isActive = true
        self.shadowView.topAnchor.constraint(equalTo: self.topPartView.topAnchor).isActive = true
        
        self.movieTitle = UILabel()
        self.movieTitle.numberOfLines = 0
        self.movieTitle.lineBreakMode = .byWordWrapping
        self.movieTitle.font = UIFont(name: "Helvetica-Bold", size: 28)
        self.movieTitle.translatesAutoresizingMaskIntoConstraints = false
        self.movieTitle.text = self.movie?.movieResponse.title
        
        self.movieGenres = UILabel()
        self.movieGenres.numberOfLines = 0
        self.movieGenres.font = UIFont(name: "Helvetica", size: 14)
        self.movieGenres.translatesAutoresizingMaskIntoConstraints = false
        self.movieGenres.tintColor = .lightGray
        self.movieGenres.alpha = 0.7
        self.setGenres()
        
        self.movieDateReleased = UILabel()
        self.movieDateReleased.numberOfLines = 0
        self.movieDateReleased.font = UIFont(name: "Helvetica", size: 14)
        self.movieDateReleased.translatesAutoresizingMaskIntoConstraints = false
        self.movieDateReleased.tintColor = .lightGray
        self.movieDateReleased.alpha = 0.7
        self.movieDateReleased.text = self.movie?.movieResponse.releaseDate
        
        self.movieOverviewLabel = UILabel()
        self.movieOverviewLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        self.movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.movieOverviewLabel.text = "Description"
        
        self.movieOverview = UILabel()
        self.movieOverview.numberOfLines = 0
        self.movieOverview.lineBreakMode = .byWordWrapping
        self.movieOverview.font = UIFont(name: "Helvetica", size: 18)
        self.movieOverview.translatesAutoresizingMaskIntoConstraints = false
        self.movieOverview.tintColor = .lightGray
        self.movieOverview.alpha = 0.9
        self.movieOverview.text = self.movie?.movieResponse.overview
    
        self.containerView.addSubview(self.topPartView)
        self.containerView.addSubview(self.movieTitle)
        self.containerView.addSubview(self.movieGenres)
        self.containerView.addSubview(self.movieDateReleased)
        self.containerView.addSubview(self.movieOverviewLabel)
        self.containerView.addSubview(self.movieOverview)
        
        self.topPartView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.topPartView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.topPartView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor).isActive = true
        self.topPartView.heightAnchor.constraint(equalTo: self.movieImage.heightAnchor).isActive = true
        
        self.movieTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
        self.movieTitle.topAnchor.constraint(equalTo: self.topPartView.bottomAnchor, constant: 15).isActive = true
        self.movieTitle.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10).isActive = true
        
        self.movieGenres.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
        self.movieGenres.topAnchor.constraint(equalTo: self.movieTitle.bottomAnchor, constant: 5).isActive = true
        self.movieGenres.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10).isActive = true
        
        self.movieDateReleased.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
        self.movieDateReleased.topAnchor.constraint(equalTo: self.movieGenres.bottomAnchor, constant: 5).isActive = true
        self.movieDateReleased.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10).isActive = true
        
        self.movieOverviewLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
        self.movieOverviewLabel.topAnchor.constraint(equalTo: self.movieDateReleased.bottomAnchor, constant: 15).isActive = true
        self.movieOverviewLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10).isActive = true
        
        self.movieOverview.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
        self.movieOverview.topAnchor.constraint(equalTo: self.movieOverviewLabel.bottomAnchor, constant: 5).isActive = true
        self.movieOverview.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20).isActive = true
        self.movieOverview.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10).isActive = true
        
        self.movieInfoScrollView.addSubview(self.containerView)
        
        self.containerView.topAnchor.constraint(equalTo: self.movieInfoScrollView.topAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.movieInfoScrollView.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.movieInfoScrollView.trailingAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.movieInfoScrollView.bottomAnchor).isActive = true
        self.containerView.widthAnchor.constraint(equalTo: self.movieInfoScrollView.widthAnchor).isActive = true

        self.view.addSubview(self.movieInfoScrollView)

        self.movieInfoScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.movieInfoScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.movieInfoScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.movieInfoScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.movieInfoScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    @objc func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
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
