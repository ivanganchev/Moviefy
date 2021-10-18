//
//  MoviesTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.09.21.
//

import Foundation
import UIKit

protocol MoviesTableViewCellDelegate: AnyObject {
    func getClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie)
}

class MoviesTableViewCell: UITableViewCell {
    static let identifier = "MoviesTableViewCell"
    
    let moviesCollectionViewLayout = MoviesCollectionViewLayout()
    var moviesCollectionViewDataSource = MoviesCollectionViewDataSource()
    weak var delegate: MoviesTableViewCellDelegate?
    
    var movieCategoryPath: String = "" {
        didSet {
            self.moviesCollectionViewDataSource.fetchMovies(movieCategoryPath: movieCategoryPath, completion: {
                self.moviesCollectionViewDataSource.loadImages {
                    DispatchQueue.main.async {
                        self.moviesCollectionViewLayout.moviesCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.moviesCollectionViewLayout.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.moviesCollectionViewLayout)
        
        NSLayoutConstraint.activate([
            self.moviesCollectionViewLayout.topAnchor.constraint(equalTo: self.topAnchor),
            self.moviesCollectionViewLayout.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.moviesCollectionViewLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.moviesCollectionViewLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.moviesCollectionViewLayout.moviesCollectionView.dataSource = self.moviesCollectionViewDataSource
        self.moviesCollectionViewLayout.moviesCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.moviesCollectionViewLayout.moviesCollectionView.reloadData()
        let layout = MoviesCollectionViewLayout.setLayout()
        self.moviesCollectionViewLayout.moviesCollectionView.collectionViewLayout = layout
        super.layoutSubviews()
    }
    
    func loadImageView(cell: UICollectionViewCell, index: Int) {
        guard let cell = cell as? MoviesCollectionViewCell else { return }
        cell.prepareForReuse()  
        
        let movie = self.moviesCollectionViewDataSource.movies[index]
        
        guard let path = movie.movieResponse.posterPath else {
            cell.image = UIImage(named: "not_loaded_image.jpg")
            return
        }
        
        if let cachedImage = self.moviesCollectionViewDataSource.cache.object(forKey: NSString(string: path)) {
            cell.image = cachedImage
        } else {
            self.moviesCollectionViewDataSource.loadImage(index: index) { image in
                DispatchQueue.main.async {
                    cell.image = image
                }
            }
        }
    }
}

extension MoviesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? MoviesCollectionViewCell
        let movie = self.moviesCollectionViewDataSource.movies[indexPath.row]
        self.delegate?.getClickedCollectionViewCell(cell: selectedCell, movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.loadImageView(cell: cell, index: indexPath.row)
    }
}
