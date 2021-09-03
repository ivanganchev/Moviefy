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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as! MoviesCollectionViewCell
        MoviesService().fetchMovieImage(imageUrl: (self.movies[indexPath.row].posterPath!), completion: {data in
            cell.data = data
        })
        
        return cell
    }
    
}

extension CategoryCollectionViewDataSource {
    func fetchMovies(completion: @escaping () -> ()) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: "1", completion: { result in
            switch result {
            case .success(let moviesResponse):
                self.movies = moviesResponse.movies!
                completion()
            case .failure(let err):
                print(err)
            }
        })
    }
}
