//
//  GenreChipsView.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import Foundation
import UIKit

protocol GenreChipsViewDelegate {
    func presentGenrePickerViewController()
    func refreshMovies()
}

class GenreChipsView: UIView, GenreChipsLayoutDelegate {
    var genreChipsCollectionView: UICollectionView?
    var genreChipsCollectionViewDataSource: GenreChipsCollectionViewDataSource = GenreChipsCollectionViewDataSource()
    var delegate: GenreChipsViewDelegate?
    var addButton: UIButton = UIButton()
    var addFilterButton: UIButton = UIButton()
    let buttonWidth = 20
    let chipViewsSpacing = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        let chipsGenreCollectionViewLayout = UICollectionViewFlowLayout()
        chipsGenreCollectionViewLayout.scrollDirection = .horizontal
        
        self.genreChipsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: chipsGenreCollectionViewLayout)
        self.genreChipsCollectionView?.backgroundColor = .white
        self.genreChipsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.genreChipsCollectionView?.dataSource = self.genreChipsCollectionViewDataSource
        self.genreChipsCollectionViewDataSource.delegate = self
        self.genreChipsCollectionView?.delegate = self
        self.genreChipsCollectionView?.register(GenreChipsCollectionViewCell.self, forCellWithReuseIdentifier: GenreChipsCollectionViewCell.identifier)
        self.genreChipsCollectionView?.isHidden = true
        
        self.addButton = UIButton(type: .custom)
        self.addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addButton.imageView?.contentMode = .scaleAspectFit
        self.addButton.contentHorizontalAlignment = .fill
        self.addButton.contentVerticalAlignment = .fill
        self.addButton.tintColor = .systemBlue
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.addTarget(self, action: #selector(addGenre), for: .touchUpInside)
        self.addButton.isHidden = true
        
        self.addFilterButton = UIButton(type: .custom)
        self.addFilterButton.setTitle("Add filter", for: .normal)
        self.addFilterButton.setTitleColor(.systemBlue, for: .normal)
        self.addFilterButton.contentHorizontalAlignment = .fill
        self.addFilterButton.contentVerticalAlignment = .fill
        self.addFilterButton.tintColor = .systemBlue
        self.addFilterButton.addTarget(self, action: #selector(addGenre), for: .touchUpInside)
        self.addFilterButton.translatesAutoresizingMaskIntoConstraints = false
        self.addFilterButton.isHidden = false
        
        self.addSubview(self.genreChipsCollectionView!)
        self.addSubview(self.addButton)
        self.addSubview(self.addFilterButton)
        
        self.genreChipsCollectionView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.genreChipsCollectionView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.genreChipsCollectionView?.trailingAnchor.constraint(equalTo: self.addButton.leadingAnchor).isActive = true
        self.genreChipsCollectionView?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.addFilterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.addFilterButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addGenre() {
        self.delegate?.presentGenrePickerViewController()
    }
    
    func hideChipsCollectioNView(isHidden: Bool) {
        if isHidden == true {
            self.genreChipsCollectionView?.isHidden = true
            self.addButton.isHidden = true
            self.addFilterButton.isHidden = false
        } else {
            self.genreChipsCollectionView?.isHidden = false
            self.addButton.isHidden = false
            self.addFilterButton.isHidden = true
        }
    }
    
    func deleteGenre() {
        self.genreChipsCollectionView?.reloadData()
        self.delegate?.refreshMovies()
    }
}

extension GenreChipsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: UILabel = UILabel()
        text.font = UIFont(name: "Helvetica", size: 20)
        text.text = self.genreChipsCollectionViewDataSource.genres[indexPath.row]
        return CGSize(width: Int(text.intrinsicContentSize.width) + self.buttonWidth + self.chipViewsSpacing * 3, height: 50)
    }
}
