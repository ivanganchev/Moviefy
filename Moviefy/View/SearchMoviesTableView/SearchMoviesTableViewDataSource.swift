//
//  SearchMoviesTableViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import Foundation
import UIKit

class SearchMoviesTableViewDataSource:NSObject, UITableViewDataSource {
    var movies:[Movie] = []
    let genres = MoviesService.genres
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieTableViewCell.identifier, for: indexPath) as! SearchMovieTableViewCell
        
        cell.image = nil

        let model = self.movies[indexPath.row]
        cell.image = model.imageData == nil ? nil : UIImage(data: model.imageData!)
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
    
    func fetchMovies(page: Int, completion: @escaping () -> ()) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: MovieCategoryEndPoint.topRatedMoviesEndPoint.rawValue, page: page, completion: { result in
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
    
    
    func searchMovies(text: String, completion: @escaping () -> ()) {
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
    
    func loadImages(completion: @escaping () -> ()) {
        self.movies.forEach { (movie) in
            if let path = movie.movieResponse.posterPath {
                MoviesService().fetchMovieImage(imageUrl: path, completion: {data in
                    movie.imageData = data
                })
            } else {
                
            }
        }
        completion()
    }
    
    
}
