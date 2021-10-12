//
//  MovieInfoViewControllerLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import Foundation
import UIKit

class MovieInfoViewControllerLayout: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    func setMovieImageView() {

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
    }
    
    func setMovieGenres() {
        self.movieGenres = UILabel()
        self.movieGenres.numberOfLines = 0
        self.movieGenres.font = UIFont(name: "Helvetica", size: 14)
        self.movieGenres.translatesAutoresizingMaskIntoConstraints = false
        self.movieGenres.tintColor = .lightGray
        self.movieGenres.alpha = 0.7
    }
    
    func setMovieDateReleased() {
        self.movieDateReleased = UILabel()
        self.movieDateReleased.numberOfLines = 0
        self.movieDateReleased.font = UIFont(name: "Helvetica", size: 14)
        self.movieDateReleased.translatesAutoresizingMaskIntoConstraints = false
        self.movieDateReleased.tintColor = .lightGray
        self.movieDateReleased.alpha = 0.7
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
        let guide = self.safeAreaLayoutGuide
        
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
        
        self.addSubview(self.movieInfoScrollView)
        
        NSLayoutConstraint.activate([
            self.movieInfoScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.movieInfoScrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            self.movieInfoScrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            self.movieInfoScrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            self.movieInfoScrollView.widthAnchor.constraint(equalTo: guide.widthAnchor)
        ])
    }
    
    func setHeart(movie: Movie) {
        let imageName = movie.id != nil ? "suit.heart.fill" : "heart"
        self.heartButton.setImage(UIImage(systemName: imageName), for: .normal)
        self.heartButton.tintColor = movie.id != nil ? .red : .white
    }
    
    func setGenres(genres: String) {
        self.movieGenres.text = genres
    }
    
    func setMovieImage(movie: Movie) {
        if let imageData = movie.imageData {
            self.movieImageView.image = UIImage(data: imageData)
        }
        
        self.movieImageView.heightAnchor.constraint(equalTo: self.movieImageView.widthAnchor, multiplier: self.movieImageView.image!.size.height / self.movieImageView.image!.size.width, constant: 0).isActive = true
    }
}
