//
//  GenreChipsCollectionView.swift
//  Moviefy
//
//  Created by A-Team Intern on 23.09.21.
//

import Foundation
import UIKit
protocol GenreChipsLayoutDelegate {
    func hideChipsCollectioNView(isHidden: Bool)
    func deleteGenre()
}

class GenreChipsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var genres: [String] = []
    var delegate: GenreChipsLayoutDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.genres.count == 0 {
            delegate?.hideChipsCollectioNView(isHidden: true)
        } else {
            delegate?.hideChipsCollectioNView(isHidden: false)
        }
        
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreChipsCollectionViewCell.identifier, for: indexPath) as! GenreChipsCollectionViewCell
        
        cell.genre = self.genres[indexPath.row]
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.deleteGenre(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteGenre(sender: UIButton) {
        self.genres.remove(at: sender.tag)
        delegate?.deleteGenre()
    }
}
