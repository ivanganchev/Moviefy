//
//  MoviesCollectionViewHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import UIKit

class MoviesCollectionViewDataSource: NSObject {
    private var movies = [Movie]()
    var imageLoadingHelper = ImageLoadingHelper()
    
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
        self.imageLoadingHelper.loadImages(movies: self.movies, completion: {
            completion()
        })
    }
    
    func loadImageView(cell: MoviesCollectionViewCell, index: Int) {
        if self.movies.count > index {
            self.imageLoadingHelper.loadImageView(cell: cell, movie: self.movies[index], index: index)
        } else {
            return
        }
    }
}

extension MoviesCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return MoviesCollectionViewCell()
        }
        
        cell.cellIndex = indexPath.row
        self.loadImageView(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MoviesCollectionViewDataSource {
    func getMovieAt(index: Int) -> Movie? {
        if index < self.movies.count {
            return self.movies[index]
        }
        return nil
    }
}
