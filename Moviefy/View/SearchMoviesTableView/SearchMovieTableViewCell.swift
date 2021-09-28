//
//  SearchMovieTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import Foundation
import UIKit

class SearchMovieTableViewCell: UITableViewCell {
    static let identifier = "SearchMoviesTableViewCell"
    
    let movieImage: UIImageView = {
        let movieImage = UIImageView()
        return movieImage
    }()
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.movieImage.image = self.image
            }
        }
    }

    let movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.font = UIFont(name: "Helvetica", size: 16)
        movieTitle.numberOfLines = 0
        return movieTitle
    }()
    
    var title: String? {
        didSet {
            DispatchQueue.main.async {
                self.movieTitle.text = self.title
            }
        }
    }
    
    let movieGenres: UILabel = {
        let movieGenres = UILabel()
        movieGenres.font = UIFont(name: "Helvetica", size: 12)
        movieGenres.tintColor = .lightGray
        return movieGenres
    }()
    
    var genres: String? {
        didSet {
            DispatchQueue.main.async {
                self.movieGenres.text = self.genres
            }
        }
    }
    
    let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .fill
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.movieImage.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    
        self.movieTitle.text = "Title"
        self.movieGenres.text = "Horror, Action"
        
        self.containerView.addArrangedSubview(self.movieTitle)
        self.containerView.addArrangedSubview(self.movieGenres)
        self.addSubview(self.movieImage)
        self.addSubview(self.containerView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.movieImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.movieImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.movieImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.movieImage.widthAnchor.constraint(equalToConstant: self.bounds.height * (500/750)).isActive = true
        
        self.containerView.leadingAnchor.constraint(equalTo: self.movieImage.trailingAnchor, constant: 15).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
}
