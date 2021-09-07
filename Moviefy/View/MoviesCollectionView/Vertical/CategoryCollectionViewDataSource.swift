//
//  CategoryCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewDataSource: NSObject,  UICollectionViewDataSource {
    
    var movies:[Movie] = []
    var movieCategoryPath: String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        MoviesService().fetchMovieImage(imageUrl: (self.movies[indexPath.row].posterPath!), completion: {data in
            cell.data = data
        })
        
        return cell
    }
}

extension CategoryCollectionViewDataSource {
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> ()) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: page, completion: { result in
            switch result {
            case .success(let moviesResponse):
                self.movies.append(contentsOf: moviesResponse.movies!)
                completion(.success(moviesResponse.movies!))
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }
}
