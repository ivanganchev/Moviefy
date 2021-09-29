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
    //Why private?
    var genreLabel: UILabel = {
        let genreLabel = UILabel()
        return genreLabel
    }()
    
    var removeButton: UIButton = {
        let removeButton = UIButton()
        return removeButton
    }()
    
    var containerView: UIStackView = {
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 5
        return containerView
    }()
    
    var view: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.genreLabel.font = UIFont(name: "Helvetica", size: 20)
        self.genreLabel.textColor = .black
        self.genreLabel.translatesAutoresizingMaskIntoConstraints = false
    
        self.removeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.removeButton.imageView?.contentMode = .scaleAspectFit
        self.removeButton.contentHorizontalAlignment = .fill
        self.removeButton.contentVerticalAlignment = .fill
        self.removeButton.tintColor = .black
        self.removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addArrangedSubview(self.genreLabel)
        self.containerView.addArrangedSubview(self.removeButton)
        self.containerView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1)))
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerView)

        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.removeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.removeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.genreLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.genreLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 5).isActive = true
        
        self.containerView.layer.cornerRadius = 12.0
        self.containerView.backgroundColor = .lightGray
        
        self.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
}
