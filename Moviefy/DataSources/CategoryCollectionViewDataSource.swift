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
    var loadedImages = [Data]()
    var currentPage = 1
    let cache = NSCache<NSNumber, UIImage>()
    
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
        var currentMovieIndex = 0
        self.filteredMovies.forEach { (movie) in
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
        completion?()
    }
    
    func loadImage(index: NSNumber, completion: ((UIImage) -> Void)? = nil) {
        let movie = self.filteredMovies[index.intValue]
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
    
    func filterMovies() {
        guard !GenreChipsCollectionViewDataSource.genres.isEmpty else {
            self.filteredMovies = self.movies
            return
        }
        let selectedGenres = GenreChipsCollectionViewDataSource.genres
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
    
    func refreshMovies(completion: @escaping () -> Void) {
        self.movies = []
        self.filteredMovies = []
        self.currentPage = 1
        self.fetchMovies {
            self.filterMovies()
            completion()
        }
   }
    
    func getMovieAtIndexPath(_ indexPath: IndexPath) -> Movie {
        return self.filteredMovies[indexPath.row]
    }
    
    func getLoadedImage() -> Movie? {
        return self.filteredMovies.first(where: { movie in
            movie.imageData != nil
        })
    }
}

extension CategoryCollectionViewDataSource: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            if filteredMovies[indexPath.row].imageData == nil {
                loadImage(index: NSNumber(value: indexPath.row), completion: {_ in })
            }
        }
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
