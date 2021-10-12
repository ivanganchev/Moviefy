//
//  GenreChipsCollectionView.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import Foundation
import UIKit

class GenreChipsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    static var genres: [String] = []
    
    var deleteAction: (() -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenreChipsCollectionViewDataSource.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreChipsCollectionViewCell.identifier, for: indexPath) as? GenreChipsCollectionViewCell else {
            return GenreChipsCollectionViewCell()
        }
        
        cell.genre = GenreChipsCollectionViewDataSource.genres[indexPath.row]
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.deleteGenre(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteGenre(sender: UIButton) {
        GenreChipsCollectionViewDataSource.genres.remove(at: sender.tag)
        deleteAction?()
    }
}
