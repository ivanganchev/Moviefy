//
//  CategoryColelctionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//

import Foundation

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = self.image
            }
        }
    }
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        self.imageView.translatesAutoresizingMaskIntoConstraints = false
//        self.imageView.contentMode = .scaleAspectFill
//        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
//        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
//        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        let width = self.bounds.width
        let height = width * (750 / 500)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        
        DispatchQueue.main.async {
            self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
}