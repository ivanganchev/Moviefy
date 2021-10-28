//
//  CategoryColelctionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func layoutSubviews() {
        let width = self.bounds.width
        let height = width * (ImageProperties.imageHeight / ImageProperties.imageWidth)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        
        DispatchQueue.main.async {
            self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
}
