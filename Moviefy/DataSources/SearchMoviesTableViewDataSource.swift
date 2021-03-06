//
//  SearchMoviesTableViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import UIKit
@testable import Moviefy

class SearchMoviesTableViewDataSource: NSObject {
    var movies: [Movie] = []
    private let genres = MoviesService.genres
    var imageLoadingHelper = ImageLoadingHelper()
    
    func resfreshMovies(completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: EndPoint.MovieCategoryEndPoint.topRated.rawValue, page: 1, completion: { result in
            self.getCompletionResult(result: result)
            completion()
       })
    }
    
    func searchMovies(text: String, completion: @escaping () -> Void) {
        MoviesService().searchMovies(text: text, completion: { result in
            self.getCompletionResult(result: result)
            completion()
        })
    }
    
    func loadImages(completion: (() -> Void)?) {
        self.imageLoadingHelper.loadImages(movies: self.movies, completion: {
            completion?()
        })
    }
    
    func loadImageView(cell: SearchMoviesTableViewCell, index: Int) {
        guard self.movies.count > index else {
            return
        }
        
        guard let movie = self.getMovie(at: index) else {
            return
        }
        
        self.imageLoadingHelper.loadImageView(cell: cell, movie: movie, index: index)
    }
    
    func getCompletionResult(result: Result<MoviesResponse, ApiMovieResponseError>) {
        switch result {
        case .success(let moviesResponse):
            let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                return Movie(movieResponse: movieResponse)
            }
            self.movies = movies ?? []
        case.failure(let err):
            self.movies = []
            print(err)
        }
    }
}

extension SearchMoviesTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesTableViewCell.identifier, for: indexPath) as? SearchMoviesTableViewCell else {
            return SearchMoviesTableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.cellIndex = indexPath.row
        self.loadImageView(cell: cell, index: indexPath.row)
        
        let model = self.getMovie(at: indexPath.row)

        cell.movieTitle.text = model?.movieResponse.title
        
        let joined = model?.genres.joined(separator: ", ")
        cell.movieGenres.text = joined
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SearchMoviesTableViewDataSource {
    func getMovies() -> [Movie] {
        return self.movies
    }
    
    func getMovie(at index: Int) -> Movie? {
        if index < self.movies.count && index >= 0 {
            return self.movies[index]
        }
        return nil
    }
    
    func getMovieImage(movie: Movie) -> UIImage? {
        guard let path = movie.movieResponse.posterPath,
              let image = self.imageLoadingHelper.cache.object(forKey: NSString(string: path))
              else {
            return nil
        }
        
        return image
    }
}
