//
//  GenreChipsCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import UIKit

class GenreChipsCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreChipsCollectionViewCell"
    
    var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.font = UIFont(name: "Helvetica", size: 20)
        genreLabel.textColor = .black
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.lineBreakMode = .byClipping
        
        return genreLabel
    }()
    
    var removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        removeButton.imageView?.contentMode = .scaleAspectFit
        removeButton.contentHorizontalAlignment = .fill
        removeButton.contentVerticalAlignment = .fill
        removeButton.tintColor = .black
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        return removeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addSubview(self.genreLabel)
        self.addSubview(self.removeButton)
        
        NSLayoutConstraint.activate([
            self.removeButton.widthAnchor.constraint(equalToConstant: 20),
            self.removeButton.heightAnchor.constraint(equalToConstant: 20),
            self.removeButton.leadingAnchor.constraint(equalTo: self.genreLabel.trailingAnchor, constant: 5),
            self.removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
            self.genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.genreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.layer.cornerRadius = 12.0
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
