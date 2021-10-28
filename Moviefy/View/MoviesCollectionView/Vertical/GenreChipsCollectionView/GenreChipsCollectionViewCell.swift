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
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.stackView.addArrangedSubview(self.genreLabel)
        self.stackView.addArrangedSubview(self.removeButton)
        
        self.stackView.setCustomSpacing(5, after: removeButton)
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.stackView)

        self.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            self.stackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            
            self.removeButton.widthAnchor.constraint(equalToConstant: 20),
            self.removeButton.heightAnchor.constraint(equalToConstant: 20),
            
            self.genreLabel.heightAnchor.constraint(equalToConstant: 25),
            self.genreLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 5),
            
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.stackView.layer.cornerRadius = 12.0
        self.stackView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
