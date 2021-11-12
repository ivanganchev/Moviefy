//
//  SavedMoviesCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.10.21.
//

import UIKit
import RealmSwift

class SavedMoviesCollectionViewDataSource: NSObject {
    private var savedMovies = [MovieEntity]()
    private var savedFilteredMovies = [MovieEntity]()
    
    private var token: NotificationToken?
    
    func registerNotificationToken(completion: @escaping (RealmCollectionChange<Results<MovieEntity>>) -> Void) {
        self.token?.invalidate()
        guard let realm = try? Realm() else {
            return
        }
        
        let results = realm.objects(MovieEntity.self)
        self.token = results.observe {(changes: RealmCollectionChange) in
            completion(changes)
        }
    }
    
    func loadSavedMovies() {
        guard let realm = try? Realm() else {
            return
        }
        
        let results = realm.objects(MovieEntity.self) 
        self.savedMovies = Array(results)
        self.savedFilteredMovies = Array(results)
    }
    
    func filterMovies(genres: [String]) {
        guard !genres.isEmpty else {
            self.savedFilteredMovies = self.savedMovies
            return
        }
        
        guard let realm = try? Realm() else {
            return
        }
        
        let movies = realm.objects(MovieEntity.self)

        self.savedFilteredMovies = FilterHelper.filterByGenres(movies: Array(movies.map({Movie(movieEntity: $0)})), selectedGenres: genres, allGenres: MoviesService.genres).map({MovieEntity(movie: $0)})
    }
}

extension SavedMoviesCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedFilteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        
        cell.cellImageView.image = nil
        
        let model = self.getSavedFilteredMovie(at: indexPath.row)
        
        if let imageData = model?.getImageDataForSavedMovie() {
            cell.cellImageView.image = UIImage(data: imageData)
        } else {
            let defaultImage = UIImage(named: "not_loaded_image.jpg")
            cell.cellImageView.image = defaultImage
        }
        
        return cell
    }
}

extension SavedMoviesCollectionViewDataSource {
    func getSavedFilteredMovie(at index: Int) -> MovieEntity? {
        if index < self.savedFilteredMovies.count {
            return self.savedFilteredMovies[index]
        }
        return nil
    }
    
    func getSavedFilteredMovies() -> [MovieEntity] {
        return self.savedFilteredMovies
    }
}
