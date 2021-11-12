//
//  GenreChipsCollectionView.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import UIKit

class GenreChipsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var genres: [String] = []
    
    var deleteAction: (() -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreChipsCollectionViewCell.identifier, for: indexPath) as? GenreChipsCollectionViewCell else {
            return GenreChipsCollectionViewCell()
        }
        
        cell.genreLabel.text = self.getGenre(at: indexPath.row)
        cell.genreLabel.isAccessibilityElement = true
        cell.genreLabel.accessibilityIdentifier = "genreLabel"
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.deleteGenre(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteGenre(sender: UIButton) {
        self.genres.remove(at: sender.tag)
        deleteAction?()
    }
}

extension GenreChipsCollectionViewDataSource {
    func getGenre(at index: Int) -> String? {
        if index < self.genres.count {
            return self.genres[index]
        }
        return nil
    }
    
    func getAllSelectedGenres() -> [String] {
        return self.genres
    }
    
    func addSelectedGenre(genre: String) {
        self.genres.append(genre)
    }
}
