//
//  MoviesCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.08.21.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MoviesCollectionViewCell"
    
    var movie: Movie? {
        didSet {
            myTextLabel.text = movie?.title
        }
    }
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.tintColor = .red
        return imageView
    }()
    
    private let myTextLabel: UILabel = {
        let myText = UILabel()
        myText.tintColor = .white
        return myText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
