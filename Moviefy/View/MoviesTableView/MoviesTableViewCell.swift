//
//  MoviesTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.09.21.
//

import UIKit

protocol MoviesTableViewCellDelegate: AnyObject {
    func moviesTableViewCell(moviesTableViewCell: MoviesTableViewCell, cell: MoviesCollectionViewCell, movie: Movie)
}

class MoviesTableViewCell: UITableViewCell {
    static let identifier = "MoviesTableViewCell"
    
    let moviesCollectionView = MoviesCollectionView()
    var moviesCollectionViewDataSource = MoviesCollectionViewDataSource()
    weak var delegate: MoviesTableViewCellDelegate?
    
    var movieCategoryPath: String = "" {
        didSet {
            self.moviesCollectionViewDataSource.fetchMovies(movieCategoryPath: movieCategoryPath, completion: {
                self.moviesCollectionViewDataSource.loadImages {
                    DispatchQueue.main.async {
                        self.moviesCollectionView.moviesCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.moviesCollectionView)
        
        NSLayoutConstraint.activate([
            self.moviesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.moviesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.moviesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.moviesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.moviesCollectionView.moviesCollectionView.dataSource = self.moviesCollectionViewDataSource
        self.moviesCollectionView.moviesCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.moviesCollectionView.moviesCollectionView.reloadData()
        let layout = MoviesCollectionView.setLayout()
        self.moviesCollectionView.moviesCollectionView.collectionViewLayout = layout
        super.layoutSubviews()
    }
}

extension MoviesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? MoviesCollectionViewCell else {
            return
        }
        guard let movie = self.moviesCollectionViewDataSource.getMovie(at: indexPath.row) else {
            return
        }
        self.delegate?.moviesTableViewCell(moviesTableViewCell: self, cell: selectedCell, movie: movie)
    }
}
