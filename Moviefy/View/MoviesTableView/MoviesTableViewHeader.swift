//
//  MoviesTableViewHeader.swift
//  Moviefy
//
//  Created by A-Team Intern on 8.10.21.
//

import UIKit

class MoviesTableViewHeader: UIView {
    
    var textLabel: String? {
        didSet {
            self.label.text = self.textLabel
        }
    }
    
    var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Helvetica-Bold", size: 26)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MoviesTableViewDelegate.headerButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(self.label)
        self.addSubview(self.button)
        
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.button.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
