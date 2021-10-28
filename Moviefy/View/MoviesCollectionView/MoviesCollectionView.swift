//
//  MoviesCollectionViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import UIKit

class MoviesCollectionView: UIView {
    var moviesCollectionView: UICollectionView = {
        let layout = MoviesCollectionView.setLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.setMoviesCollectionView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoviesCollectionView() {
        self.moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.moviesCollectionView.backgroundColor = .white
        self.moviesCollectionView.showsHorizontalScrollIndicator = false
        self.moviesCollectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
    }
    
    static func setLayout() -> UICollectionViewFlowLayout {
        let size = ImageProperties.getThumbnailImageSize()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: size.width, height: size.height)
    
        return layout
    }
    
    func setConstraints() {
        self.addSubview(moviesCollectionView)

        NSLayoutConstraint.activate([
            self.moviesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.moviesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.moviesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.moviesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
