//
//  SearchMoviesTableViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import Foundation
import UIKit

class SearchMoviesTableViewDataSource: NSObject, UITableViewDataSource {
    var movies: [Movie] = []
    let genres = MoviesService.genres
    let cache = NSCache<NSString, UIImage>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesTableViewCell.identifier, for: indexPath) as? SearchMoviesTableViewCell else {
            return SearchMoviesTableViewCell()
        }
        
        let model = self.movies[indexPath.row]

        cell.title = model.movieResponse.title
        
        let arrayOfGenres: [String] = model.movieResponse.genreIds?.compactMap({ id in
            return genres?[id]
        }) ?? []
        let joined = arrayOfGenres.joined(separator: ", ")
        cell.genres = joined
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SearchMoviesTableViewDataSource {
    
    func fetchMovies(page: Int, completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: EndPoint.MovieCategoryEndPoint.topRated.rawValue, page: page, completion: { result in
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
    
    func searchMovies(text: String, completion: @escaping () -> Void) {
        MoviesService().searchMovies(text: text, completion: {result in
            switch result {
            case .success(let moviesResponse):
                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                self.movies = movies ?? []
                completion()
            case.failure(let err):
                print(err)
            }
        })
    }
    
    func loadImages(completion: @escaping () -> Void) {
        self.movies.forEach { (movie) in
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
        completion()
    }
    
    func loadImage(index: Int, completion: ((UIImage) -> Void)? = nil) {
        guard index >= 0 && index < self.movies.count else {
            return
        }
        
        let movie = self.movies[index]
        
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
}
