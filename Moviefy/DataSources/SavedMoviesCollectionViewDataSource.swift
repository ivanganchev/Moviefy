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
    var savedFilteredMovies = [MovieEntity]()
    
    private var token: NotificationToken?
    
    var imageLoadingHelper = ImageLoadingHelper()
    
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
        
        if let image = self.getImageForSavedMovie(at: indexPath.row) {
            cell.cellImageView.image = image
        } else {
            guard let movie = self.getSavedFilteredMovie(at: indexPath.row), movie.posterPath != nil else {
                let defaultImage = UIImage(named: "not_loaded_image.jpg")
                cell.cellImageView.image = defaultImage
                return cell
            }
            
            self.imageLoadingHelper.loadImage(movie: Movie(movieEntity: movie), completion: { image in
                guard let path = movie.imageLocalPath, let data = image.pngData() else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.cellImageView.image = image
                }
                
                LocalPathFileManager.saveData(path: path, data: data)
            })
        }
        
        return cell
    }
}

extension SavedMoviesCollectionViewDataSource {
    func getSavedFilteredMovie(at index: Int) -> MovieEntity? {
        if index < self.savedFilteredMovies.count && index >= 0 {
            return self.savedFilteredMovies[index]
        }
        return nil
    }
    
    func getSavedFilteredMovies() -> [MovieEntity] {
        return self.savedFilteredMovies
    }
    
    func getImageForSavedMovie(at index: Int) -> UIImage? {
        let model = self.getSavedFilteredMovie(at: index)
        guard let imageLocalPath = model?.imageLocalPath else {
            return nil
        }
        
        return LocalPathFileManager.getImage(at: imageLocalPath)
    }
}
