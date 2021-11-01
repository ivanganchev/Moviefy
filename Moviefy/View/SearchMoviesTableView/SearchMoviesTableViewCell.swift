//
//  SearchMovieTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import UIKit

class SearchMoviesTableViewCell: UITableViewCell, ThumbnailCell {
    static let identifier = "SearchMoviesTableViewCell"
    
    var cellImageView = UIImageView()
    var cellIndex = 0

    let movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.font = UIFont(name: "Helvetica", size: 16)
        movieTitle.numberOfLines = 0
        return movieTitle
    }()
    
    let movieGenres: UILabel = {
        let movieGenres = UILabel()
        movieGenres.font = UIFont(name: "Helvetica", size: 12)
        movieGenres.tintColor = .lightGray
        return movieGenres
    }()
    
    let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cellImageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addArrangedSubview(self.movieTitle)
        self.containerView.addArrangedSubview(self.movieGenres)
        self.contentView.addSubview(self.cellImageView)
        self.contentView.addSubview(self.containerView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = ImageProperties.getThumbnailImageSize()
        NSLayoutConstraint.activate([
            self.cellImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.cellImageView.widthAnchor.constraint(equalToConstant: size.height * (ImageProperties.imageWidth / ImageProperties.imageHeight)),
            self.cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.cellImageView.trailingAnchor, constant: 15),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageView.image = nil
    }
}
