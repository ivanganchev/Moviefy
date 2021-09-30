//
//  MoviesCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.08.21.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MoviesCollectionViewCell"
    
//    var data: Data? {
//        didSet {
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: self.data!)
//            }
//        }
//    }
    
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
        
        DispatchQueue.main.async {
            self.imageView.frame = CGRect(origin: .zero, size: ThumbnailImageProperties.getSize())
        }
    }
}
