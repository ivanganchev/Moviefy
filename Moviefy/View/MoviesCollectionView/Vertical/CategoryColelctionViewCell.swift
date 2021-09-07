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
    
    var data: Data? {
        didSet {
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(data: self.data!)
            }
        }
    }
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.myImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3.0, height: UIScreen.main.bounds.height/4.0)
    }
}
