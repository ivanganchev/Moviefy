//
//  CategoryCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewDataSource: NSObject,  UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {

    var movies:[Movie] = []
    var movieCategoryPath: String?
    var loadedImages: [Data] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.image = nil

        let model = self.movies[indexPath.row]
        cell.image = model.imageData == nil ? nil : UIImage(data: model.imageData!)
    
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            if movies[indexPath.row].imageData == nil {
                loadImage(movie: movies[indexPath.row])
            }
        }
    }
    
}

extension CategoryCollectionViewDataSource {
//    func fetchMovies(page: Int, completion: @escaping () -> (), completion2: @escaping () -> ()) {
//        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: page, completion: { result in
//            switch result {
//            case .success(let moviesResponse):
//                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
//                    return Movie(movieResponse: movieResponse)
//                }
//                self.movies.append(contentsOf: movies ?? [])
//
//                self.movies.forEach { (movie) in
//                    guard let path = movie.movieResponse.posterPath else {
//                        return
//                    }
//
//                    MoviesService().fetchMovieImage(imageUrl: path, completion: {data in
//                        movie.imageData = data
//                        completion()
//                    })
//                }
//                completion2()
//            case .failure(let err):
//                print(err)
//            }
//        })
//    }
    
    func fetchMovies(page: Int, completion: @escaping () -> ()) {
            MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: page, completion: { result in
               switch result {
               case .success(let moviesResponse):
                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                self.movies.append(contentsOf: movies ?? [])
                completion()
               case .failure(let err):
                   print(err)
               }
           })
       }
    
    func loadImages(completion: @escaping () -> ()) {
        self.movies.forEach { (movie) in
            guard let path = movie.movieResponse.posterPath else {
                return
            }

            MoviesService().fetchMovieImage(imageUrl: path, completion: {data in
                movie.imageData = data
                
            })
        }
        completion()
    }
    
    func loadImage(movie: Movie) {
        MoviesService().fetchMovieImage(imageUrl: movie.movieResponse.posterPath!, completion: {data in
            movie.imageData = data
        })
    }
}
