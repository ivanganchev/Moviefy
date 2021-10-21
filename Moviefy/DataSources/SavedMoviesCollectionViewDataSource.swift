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
    var savedMovies = [MovieEntity]()
    var savedFilteredMovies = [MovieEntity]()
    
    var token: NotificationToken?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedFilteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        
        cell.image = nil
        
        let model = savedFilteredMovies[indexPath.row]
        
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
    func registerNotificationToken(completion: @escaping (RealmCollectionChange<Results<MovieEntity>>) -> Void) {
        self.token?.invalidate()
        let realm = try? Realm()
        guard let results = realm?.objects(MovieEntity.self) else {
            return
        }
        // values capturing
        self.token = results.observe {(changes: RealmCollectionChange) in
            completion(changes)
        }
    }
    
    func loadSavedMovies() {
        let realm = try? Realm()
        guard let results = realm?.objects(MovieEntity.self) else {
            return
        }
        self.savedMovies = Array(results)
        self.savedFilteredMovies = Array(results)
    }
    
    func filterMovies(genres: [String]) {
        guard !genres.isEmpty else {
            self.savedFilteredMovies = self.savedMovies
            return
        }
        let realm = try? Realm()
        guard let movies = realm?.objects(MovieEntity.self) else { return }

        self.savedFilteredMovies = FilterHelper.filterByGenres(movies: Array(movies.map({Movie(movieEntity: $0, imageData: $0.imageData!)})), selectedGenres: genres, allGenres: MoviesService.genres).map({MovieEntity(movie: $0)})
    }
}
