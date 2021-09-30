//
//  MoviesTableViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.09.21.
//

import Foundation
import UIKit

protocol MoviesTableViewCellDelegate {
    func getClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie?)
}
class MoviesTableViewCell : UITableViewCell {
    
    static let identifier = "MoviesTableViewCell"
    var moviesCollectionViewDataSource: MoviesCollectionViewDataSource?
    var moviesCollectionView: UICollectionView?
    var moviesCollectionViewLayout: UICollectionViewFlowLayout?
    var delegate: MoviesTableViewCellDelegate?
    
    var movieCategoryPath: String = "" {
        didSet {
            self.moviesCollectionViewDataSource?.fetchMovies(movieCategoryPath: movieCategoryPath, completion: {
                self.moviesCollectionViewDataSource?.loadImages {
                    DispatchQueue.main.async {
                        self.moviesCollectionView?.reloadData()
                    }
                }
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = self.setLayout()
        self.moviesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: layout.itemSize.height), collectionViewLayout: layout)

        self.moviesCollectionView?.backgroundColor = .white
        self.moviesCollectionView?.showsHorizontalScrollIndicator = false
        self.moviesCollectionViewDataSource = MoviesCollectionViewDataSource()
        self.moviesCollectionView!.dataSource = self.moviesCollectionViewDataSource
        self.moviesCollectionView?.delegate = self
        self.moviesCollectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        self.contentView.addSubview(moviesCollectionView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.moviesCollectionView?.reloadData()
        let layout = setLayout()
        self.moviesCollectionView?.collectionViewLayout = layout
        self.moviesCollectionView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: layout.itemSize.height)
        super.layoutSubviews()
    }
    
    private func setLayout() -> UICollectionViewFlowLayout{
        let size = ThumbnailImageProperties.getSize()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: size.width, height: size.height)
    
        return layout
    }
}

extension MoviesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? MoviesCollectionViewCell
        self.delegate?.getClickedCollectionViewCell(cell: selectedCell, movie: self.moviesCollectionViewDataSource?.movies[indexPath.row])
    }
}
