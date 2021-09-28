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
    var moviesCollectionViewLayout: UICollectionViewFlowLayout?
    
    var movieCategoryPath: String = "" {
        didSet {
            self.moviesCollectionViewDataSource?.fetchMovies(movieCategoryPath: movieCategoryPath, completion: {
                DispatchQueue.main.async {
                    self.moviesCollectionView?.reloadData()
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
        self.moviesCollectionView!.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        contentView.addSubview(moviesCollectionView!)
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
        var ratio = 1.0
        let orientation = UIDevice.current.orientation
        switch orientation {
            case .portrait:
                ratio = 0.33
            case .portraitUpsideDown:
                ratio = 0.33
            case .landscapeLeft:
                ratio = 0.33 / 2
            case .landscapeRight:
                ratio = 0.33 / 2
            default:
                ratio = 1.0
        }
        let width = UIScreen.main.bounds.width * CGFloat(ratio)
        let height = width * (750 / 500)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
    
        return layout
    }
}
