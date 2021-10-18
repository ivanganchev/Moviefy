//
//  CategoryCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewDataSource: NSObject {
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var movieCategoryPath: String?
    var currentPage = 1
    let cache = NSCache<NSString, UIImage>()
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    func fetchMovies(completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: self.currentPage, completion: { result in
               switch result {
               case .success(let moviesResponse):
                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                self.movies.append(contentsOf: movies ?? [])
                self.filteredMovies = self.movies
                self.currentPage += 1
                completion()
               case .failure(let err):
                   print(err)
               }
           })
    }
    
    func loadImages(completion: (() -> Void)? = nil) {
        self.filteredMovies.forEach { (movie) in
            guard let posterPath = movie.movieResponse.posterPath else {
                return
            }
            
            let path = NSString(string: posterPath)
            
            MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
                switch result {
                case .success(let data):
                    movie.imageData = data
                    self.cache.setObject(UIImage(data: data)!, forKey: path)
                case .failure(let err):
                    print(err)
                }
            })
        }
        completion?()
    }
    
    func loadImage(index: Int, completion: ((UIImage) -> Void)? = nil) {
        guard index >= 0 && index < self.filteredMovies.count else {
            return
        }
        
        let movie: Movie = self.filteredMovies[index]
        
        guard let posterPath = movie.movieResponse.posterPath else {
            return
        }
        
        let path = NSString(string: posterPath)
        
        MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
            switch result {
            case .success(let data):
                movie.imageData = data
                let loadedImage = UIImage(data: data)!
                self.cache.setObject(loadedImage, forKey: path)
                completion!(loadedImage)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func filterMovies(genres: [String]) {
        guard !genres.isEmpty else {
            self.filteredMovies = self.movies
            return
        }
        let selectedGenres = genres
        let allGenres = MoviesService.genres
        var newFilteredMovies: [Movie] = movies
        
        selectedGenres.forEach({ genre in
            var tempArr: [Movie] = []
            newFilteredMovies.forEach { movie in
                let id = allGenres?.first(where: {$0.value == genre})?.key
                if movie.movieResponse.genreIds!.contains(id!) {
                    tempArr.append(movie)
                }
            }
            newFilteredMovies = tempArr
        })
        
        self.filteredMovies = newFilteredMovies
    }
    
    func refreshMovies(genres: [String], completion: @escaping () -> Void) {
        self.movies = []
        self.filteredMovies = []
        self.currentPage = 1
        self.fetchMovies {
            self.filterMovies(genres: genres)
            completion()
        }
   }
}

extension CategoryCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IndicatorFooter.identifier, for: indexPath)
            footer.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.frame = CGRect(origin: .zero, size: CGSize(width: collectionView.bounds.width, height: 50))
            return footer
        }
        return UICollectionReusableView()
    }
}
