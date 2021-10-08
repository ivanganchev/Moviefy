//
//  GenreChipsCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import Foundation
import UIKit

class GenreChipsCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreChipsCollectionViewCell"
    
    var genre: String? {
        didSet {
            DispatchQueue.main.async {
                self.genreLabel.text = self.genre
            }
        }
    }
    
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
    
    var containerView: UIStackView = {
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    var view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.containerView.addArrangedSubview(self.genreLabel)
        self.containerView.addArrangedSubview(self.removeButton)
        self.containerView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1)))
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerView)

        self.addSubview(self.view)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            self.removeButton.widthAnchor.constraint(equalToConstant: 20),
            self.removeButton.heightAnchor.constraint(equalToConstant: 20),
            
            self.genreLabel.heightAnchor.constraint(equalToConstant: 25),
            self.genreLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 5),
            
            self.view.topAnchor.constraint(equalTo: self.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.containerView.layer.cornerRadius = 12.0
        self.containerView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
