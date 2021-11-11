//
//  CategoryCollectionViewLayout.swift
//  Moviefy
//
//  Created by A-Team Intern on 12.10.21.
//

import UIKit

class CategoryCollectionView: UIView {
    let categoryCollectionView: UICollectionView = {
        let categoryCollectionViewLayout = UICollectionViewFlowLayout()
        categoryCollectionViewLayout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout)
    }()
    
    let genreChipsView = GenreChipsView(frame: .zero)
    let barTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
    let emptyCollectionViewText: UILabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.setBarTitle()
        self.setCategoryCollectionView()
        self.setGenreChipsView()
        self.setEmptyCollectionViewText()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBarTitle() {
        self.barTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
    }
    
    func setCategoryCollectionView() {
        self.categoryCollectionView.backgroundColor = .white
        self.categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.categoryCollectionView.register(FooterIndicator.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterIndicator.identifier)
    }
    
    func setGenreChipsView() {
        let chipsGenreCollectionViewLayout = UICollectionViewFlowLayout()
        chipsGenreCollectionViewLayout.scrollDirection = .horizontal
        
        self.genreChipsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setEmptyCollectionViewText() {
        self.emptyCollectionViewText.translatesAutoresizingMaskIntoConstraints = false
        self.emptyCollectionViewText.text = "No movies found"
        self.emptyCollectionViewText.font = UIFont(name: "Helvetica", size: 16)
        self.emptyCollectionViewText.textAlignment = .center
        self.emptyCollectionViewText.isHidden = true
    }
    
    func setConstraints() {
        let guide = self.safeAreaLayoutGuide
    
        self.addSubview(self.categoryCollectionView)
        self.addSubview(self.genreChipsView)
        self.addSubview(self.emptyCollectionViewText)
        
        NSLayoutConstraint.activate([
            self.categoryCollectionView.topAnchor.constraint(equalTo: self.genreChipsView.bottomAnchor),
            self.categoryCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.categoryCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.categoryCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.genreChipsView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.genreChipsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.genreChipsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.genreChipsView.heightAnchor.constraint(equalToConstant: 50),
            self.genreChipsView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            self.emptyCollectionViewText.topAnchor.constraint(equalTo: self.topAnchor),
            self.emptyCollectionViewText.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.emptyCollectionViewText.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.emptyCollectionViewText.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setLayoutBackgroundView(isEmpty: Bool) {
        DispatchQueue.main.async {
            self.categoryCollectionView.isHidden = isEmpty
            self.emptyCollectionViewText.isHidden = !isEmpty
        }
    }
}
