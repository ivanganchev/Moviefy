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
    let cache = NSCache<NSNumber, UIImage>()
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return MoviesCollectionViewCell()
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
        var currentMovieIndex = 0
        self.movies.forEach { (movie) in
            if let path = movie.movieResponse.posterPath {
                MoviesService().fetchMovieImage(imageUrl: path, completion: {result in
                    switch result {
                    case .success(let data):
                        movie.imageData = data
                        self.cache.setObject(UIImage(data: data)!, forKey: NSNumber(value: currentMovieIndex))
                        currentMovieIndex += 1
                    case .failure(let err):
                        print(err)
                    }
                })
            } else {
                self.cache.setObject(UIImage(named: "not_loaded_image.jpg")!, forKey: NSNumber(value: currentMovieIndex))
            }
        }
        completion()
    }
    
    func loadImage(index: NSNumber, completion: ((UIImage) -> Void)? = nil) {
        let movie = self.movies[index.intValue]
        if let path = movie.movieResponse.posterPath {
            MoviesService().fetchMovieImage(imageUrl: path, completion: {result in
                switch result {
                case .success(let data):
                    movie.imageData = data
                    let loadedImage = UIImage(data: data)!
                    self.cache.setObject(loadedImage, forKey: index)
                    completion!(loadedImage)
                case .failure(let err):
                    print(err)
                }
            })
        }
    }
}
