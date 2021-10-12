//
//  GenreChipsCollectionViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import Foundation
import UIKit

class GenreChipsCollectionViewLayout: UIView {
    let maxDimmedAlpha: CGFloat = 0.6
    let defaultHeight: CGFloat = 300
    var currentContainerHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view .clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = self.maxDimmedAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genrePickerView: UIPickerView = {
        let genrePickerView = UIPickerView()
        return genrePickerView
    }()
    
    lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    lazy var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .lightGray
    
        let titleLabel = UILabel()
        titleLabel.text = "Genres"
        titleLabel.font = UIFont(name: "Helvetica", size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.sizeToFit()
        
        barView.addSubview(self.doneButton)
        barView.addSubview(self.closeButton)
        barView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: barView.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -10),
            doneButton.topAnchor.constraint(equalTo: barView.topAnchor),
            doneButton.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: barView.centerYAnchor)
        ])
        
        return barView
    }()
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.addSubview(self.dimmedView)
        self.addSubview(self.containerView)

        self.containerView.addSubview(self.genrePickerView)
        self.containerView.addSubview(self.barView)
        self.genrePickerView.translatesAutoresizingMaskIntoConstraints = false
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dimmedView.topAnchor.constraint(equalTo: self.topAnchor),
            self.dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.containerViewHeightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: self.defaultHeight)
        self.containerViewBottomConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.defaultHeight)
        
        self.containerViewHeightConstraint?.isActive = true
        self.containerViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            self.barView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.barView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.barView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.barView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            self.genrePickerView.topAnchor.constraint(equalTo: self.barView.bottomAnchor),
            self.genrePickerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.genrePickerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.genrePickerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }
    
}
