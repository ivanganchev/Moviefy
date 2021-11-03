//
//  SearchMoviesTableViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 17.09.21.
//

import UIKit

class SearchMoviesTableViewDataSource: NSObject {
    private var movies: [Movie] = []
    private let genres = MoviesService.genres
    private var imageLoadingHelper = ImageLoadingHelper()
    
    func resfreshMovies(completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: EndPoint.MovieCategoryEndPoint.topRated.rawValue, page: 1,  completion: { result in
            self.getCompletionResult(result: result)
            completion()
       })
    }
    
    func searchMovies(text: String, completion: @escaping () -> Void) {
        MoviesService().searchMovies(text: text, completion: {result in
            self.getCompletionResult(result: result)
            completion()
        })
    }
    
    func loadImages(completion: @escaping () -> Void) {
        self.imageLoadingHelper.loadImages(movies: self.movies, completion: {
            completion()
        })
    }
    
    func loadImageView(cell: SearchMoviesTableViewCell, index: Int) {
        if self.movies.count > index {
            self.imageLoadingHelper.loadImageView(cell: cell, movie: self.movies[index], index: index)
        } else {
            return
        }
    }
    
    func getCompletionResult(result: Result<MoviesResponse, ApiResponseCustomError>) {
        switch result {
        case .success(let moviesResponse):
            let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                return Movie(movieResponse: movieResponse)
            }
            self.movies = movies ?? []
        case.failure(let err):
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
        
        let model = self.movies[indexPath.row]

        cell.movieTitle.text = model.movieResponse.title
        
        let joined = model.genres?.joined(separator: ", ")
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
    
    func getMovieAt(index: Int) -> Movie? {
        if index < self.movies.count {
            return self.movies[index]
        }
        return nil
    }
}
