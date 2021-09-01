//
//  MoviesTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.09.21.
//

import Foundation
import UIKit

class MoviesTableViewCell : UITableViewCell {
    
    static let identifier = "MoviesTableViewCell"
    var moviesCollectionViewDataSource: MoviesCollectionViewDataSource?
    var moviesCollectionView: UICollectionView?
    
    var movies: [Movie] = [] {
        didSet {
            self.moviesCollectionViewDataSource?.movies = movies
            self.moviesCollectionView?.reloadData()
        }
    }
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.moviesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 440, height: 100), collectionViewLayout: layout)
        self.moviesCollectionViewDataSource = MoviesCollectionViewDataSource()
        self.moviesCollectionView!.dataSource = self.moviesCollectionViewDataSource
        self.moviesCollectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        contentView.addSubview(moviesCollectionView!)
        self.moviesCollectionView?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.moviesCollectionView?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.moviesCollectionView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
}
