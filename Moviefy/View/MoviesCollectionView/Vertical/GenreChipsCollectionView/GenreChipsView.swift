//
//  GenreChipsView.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import UIKit

protocol GenreChipsViewDelegate: AnyObject {
    func didSelectAddGenre(genreChipsView: GenreChipsView)
}

class GenreChipsView: UIView {
    var genreChipsCollectionView: UICollectionView = {
        let chipsGenreCollectionViewLayout = UICollectionViewFlowLayout()
        chipsGenreCollectionViewLayout.scrollDirection = .horizontal
        
        return UICollectionView(frame: .zero, collectionViewLayout: chipsGenreCollectionViewLayout)
    }()
    weak var delegate: GenreChipsViewDelegate?
    var addButton: UIButton = UIButton()
    var addFilterButton: UIButton = UIButton()
    let buttonWidth = 20
    let chipViewsSpacing = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.setGenreChipsCollectionView()
        self.setAddButton()
        self.setAddFilterButton()
        self.setConstraints()
    }
    
    func setGenreChipsCollectionView() {
        self.genreChipsCollectionView.backgroundColor = .white
        self.genreChipsCollectionView.translatesAutoresizingMaskIntoConstraints = false
         self.genreChipsCollectionView.delegate = self
        self.genreChipsCollectionView.register(GenreChipsCollectionViewCell.self, forCellWithReuseIdentifier: GenreChipsCollectionViewCell.identifier)
        self.genreChipsCollectionView.isHidden = true
    }
    
    func setAddButton() {
        self.addButton = UIButton(type: .custom)
        self.addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.addButton.imageView?.contentMode = .scaleAspectFit
        self.addButton.contentHorizontalAlignment = .fill
        self.addButton.contentVerticalAlignment = .fill
        self.addButton.tintColor = .systemBlue
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.addTarget(self, action: #selector(addGenre), for: .touchUpInside)
        self.addButton.isHidden = true
    }
    
    func setAddFilterButton() {
        self.addFilterButton = UIButton(type: .custom)
        self.addFilterButton.setTitle("Add filter", for: .normal)
        self.addFilterButton.setTitleColor(.systemBlue, for: .normal)
        self.addFilterButton.contentHorizontalAlignment = .fill
        self.addFilterButton.contentVerticalAlignment = .fill
        self.addFilterButton.tintColor = .systemBlue
        self.addFilterButton.addTarget(self, action: #selector(addGenre), for: .touchUpInside)
        self.addFilterButton.translatesAutoresizingMaskIntoConstraints = false
        self.addFilterButton.isHidden = false
    }
    
    func setConstraints() {
        self.addSubview(self.genreChipsCollectionView)
        self.addSubview(self.addButton)
        self.addSubview(self.addFilterButton)
        
        NSLayoutConstraint.activate([
            self.genreChipsCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.genreChipsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.genreChipsCollectionView.trailingAnchor.constraint(equalTo: self.addButton.leadingAnchor),
            self.genreChipsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            self.addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.addButton.widthAnchor.constraint(equalToConstant: 25),
            self.addButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.addFilterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.addFilterButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addGenre() {
        self.delegate?.didSelectAddGenre(genreChipsView: self)
    }
    
    func hideChipsCollectionView(isHidden: Bool) {
        self.genreChipsCollectionView.isHidden = isHidden
        self.addButton.isHidden = isHidden
        self.addFilterButton.isHidden = !isHidden
    }
}

extension GenreChipsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: UILabel = UILabel()
        text.font = UIFont(name: "Helvetica", size: 20)
        if let dataSource = self.genreChipsCollectionView.dataSource as? GenreChipsCollectionViewDataSource {
            text.text = dataSource.getGenre(at: indexPath.row)
        }
        return CGSize(width: Int(text.intrinsicContentSize.width) + self.buttonWidth + self.chipViewsSpacing * 3, height: 30)
    }
}
