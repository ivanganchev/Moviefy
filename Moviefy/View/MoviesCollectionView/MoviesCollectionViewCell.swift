//
//  MoviesCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.08.21.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell, ThumbnailCell {
    static let identifier = "MoviesCollectionViewCell"

    var cellImageView = UIImageView()
    var cellIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(self.cellImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.cellImageView.frame = CGRect(origin: .zero, size: ImageProperties.getThumbnailImageSize())
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageView.image = nil
    }
}
