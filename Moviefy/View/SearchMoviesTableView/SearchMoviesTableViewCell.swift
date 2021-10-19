//
//  SearchMovieTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import Foundation
import UIKit

class SearchMoviesTableViewCell: UITableViewCell {
    static let identifier = "SearchMoviesTableViewCell"
    
    let movieImage = UIImageView()
    
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
        view.alignment = .fill
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.movieImage.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addArrangedSubview(self.movieTitle)
        self.containerView.addArrangedSubview(self.movieGenres)
        self.contentView.addSubview(self.movieImage)
        self.contentView.addSubview(self.containerView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = ThumbnailImageProperties.getSize()
        NSLayoutConstraint.activate([
            self.movieImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            self.movieImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            self.movieImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.movieImage.heightAnchor.constraint(equalToConstant: size.height - 3),
            self.movieImage.widthAnchor.constraint(equalToConstant: size.height * (500/750)),
            self.containerView.leadingAnchor.constraint(equalTo: self.movieImage.trailingAnchor, constant: 15),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImage.image = nil
    }
}
