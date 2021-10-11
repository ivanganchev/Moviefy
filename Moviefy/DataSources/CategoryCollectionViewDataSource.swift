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
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    func fetchMovies(completion: @escaping () -> ()) {
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
    
    func loadImages(completion: (() -> ())? = nil) {
        self.filteredMovies.forEach { (movie) in
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
        completion?()
    }
    
    func loadImage(movie: Movie, completion: (() -> ())? = nil) {
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
    
    func filterMovies(genres: [String]) {
        let allGenres = MoviesService.genres
        let selectedGenres = genres
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
    
    func refreshMovies(completion: @escaping () -> ()) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: self.currentPage, completion: { result in
           switch result {
           case .success(let moviesResponse):
            let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                return Movie(movieResponse: movieResponse)
            }
            self.movies = movies ?? []
            self.filteredMovies = self.movies
            self.currentPage += 1
            completion()
           case .failure(let err):
               print(err)
           }
        })
   }
    
    func getMovieAtIndexPath(_ indexPath: IndexPath) -> Movie {
        return self.filteredMovies[indexPath.row]
    }
    
    func getLoadedImage() -> Movie?{
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.image = nil
        let model = self.filteredMovies[indexPath.row]
        
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
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            if filteredMovies[indexPath.row].imageData == nil {
                loadImage(movie: movies[indexPath.row], completion: {})
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

