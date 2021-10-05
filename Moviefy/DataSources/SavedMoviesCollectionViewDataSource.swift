//
//  SavedMoviesCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import Foundation
import UIKit
import RealmSwift

class SavedMoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var savedMovies: [MovieEntity] = []
    var token: NotificationToken?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.image = nil
        
        let model = savedMovies[indexPath.row]
        
        if let imageData = model.imageData {
            cell.image = UIImage(data: imageData)
        } else {
            let defaultImage = UIImage(named: "not_loaded_image.jpg")
            cell.image = defaultImage
        }
        
        return cell
    }
}

extension SavedMoviesCollectionViewDataSource {
    func loadSavedMovies(completion: @escaping (RealmCollectionChange<Results<MovieEntity>>) -> ()) {
        let realm: Realm = try! Realm()
        let results = realm.objects(MovieEntity.self)
        self.savedMovies = Array(results)
        self.token?.invalidate()
        self.token = results.observe {[weak self] (changes: RealmCollectionChange) in
            completion(changes)
        }
    }
}
