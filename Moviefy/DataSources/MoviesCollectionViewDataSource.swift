//
//  MoviesCollectionViewHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation
import UIKit

class MoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var movies: [Movie] = []
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return MoviesCollectionViewCell()
        }
        
        cell.image = nil
        let model = self.movies[indexPath.row]
        
        if model.movieResponse.posterPath != nil {
            if let imageData = model.imageData {
                cell.image = UIImage(data: imageData)
            } else {
                self.loadImage(movie: model) {
                    DispatchQueue.main.async {
                        cell.image = UIImage(data: self.movies[indexPath.row].imageData!)
                    }
                }
            }
        } else {
            let defaultImage = UIImage(named: "not_loaded_image.jpg")
            cell.image = defaultImage
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MoviesCollectionViewDataSource {
    func fetchMovies(movieCategoryPath: String, completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: movieCategoryPath, page: 1, completion: { result in
           switch result {
           case .success(let moviesResponse):
                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                self.movies = movies ?? []
                completion()
           case .failure(let err):
               print(err)
           }
       })
    }
    
    func loadImages(completion: @escaping () -> Void) {
        self.movies.forEach { (movie) in
            if let path = movie.movieResponse.posterPath {
                MoviesService().fetchMovieImage(imageUrl: path, completion: {result in
                    switch result {
                    case .success(let data):
                        movie.imageData = data
                    case .failure(let err):
                        print(err)
                    }
                })
            }
        }
        completion()
    }
    
    func loadImage(movie: Movie, completion: @escaping () -> Void) {
        if let path = movie.movieResponse.posterPath {
            MoviesService().fetchMovieImage(imageUrl: path, completion: {result in
                switch result {
                case .success(let data):
                    movie.imageData = data
                case .failure(let err):
                    print(err)
                }
            })
        }
    }
}
