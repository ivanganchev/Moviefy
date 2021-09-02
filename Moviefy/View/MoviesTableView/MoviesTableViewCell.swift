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
        layout.itemSize = CGSize(width: 140, height: 200)
        self.moviesCollectionView = UICollectionView(frame: CGRect(x: 10, y: 0, width: 390, height: 200), collectionViewLayout: layout)
        self.moviesCollectionView?.backgroundColor = .clear
        self.moviesCollectionViewDataSource = MoviesCollectionViewDataSource()
        self.moviesCollectionView!.dataSource = self.moviesCollectionViewDataSource
        self.moviesCollectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        contentView.addSubview(moviesCollectionView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
}
