//
//  SavedMoviesCollectionViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import UIKit

class SavedMoviesView: UIView {
    let savedMoviesCollectionView: UICollectionView = {
        let savedMoviesCollectionViewFlowLayout = UICollectionViewFlowLayout()
        savedMoviesCollectionViewFlowLayout.scrollDirection = .vertical
    
        return UICollectionView(frame: .zero, collectionViewLayout: savedMoviesCollectionViewFlowLayout)
    }()
    
    let barTitle: UILabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.setBarTitle()
        self.setSavedMoviesCollectionView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBarTitle() {
        self.barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        self.barTitle.text = "My List"
        self.barTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setSavedMoviesCollectionView() {
        self.savedMoviesCollectionView.backgroundColor = .white

        self.savedMoviesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.savedMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        self.addSubview(self.savedMoviesCollectionView)
        
        NSLayoutConstraint.activate([
            self.savedMoviesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.savedMoviesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.savedMoviesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.savedMoviesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.barTitle.widthAnchor.constraint(equalToConstant: 50),
            self.barTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
