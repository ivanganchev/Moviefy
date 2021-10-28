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
    let cache = NSCache<NSString, UIImage>()
    
    func resfreshMovies(completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: EndPoint.MovieCategoryEndPoint.topRated.rawValue, page: 1, completion: { result in
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
        self.movies.forEach { (movie) in
            guard let posterPath = movie.movieResponse.posterPath else {
                return
            }
            
            let path = NSString(string: posterPath)
            
            MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    self.cache.setObject(image, forKey: path)
                    movie.imageData = data
                case .failure(let err):
                    print(err)
                }
            })
        }
        completion()
    }
    
    func loadImage(movie: Movie, completion: ((UIImage) -> Void)? = nil) {
        guard let posterPath = movie.movieResponse.posterPath else {
            return
        }
        
        let path = NSString(string: posterPath)
        
        MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
            switch result {
            case .success(let data):
                guard let loadedImage = UIImage(data: data) else {
                    return
                }
                self.cache.setObject(loadedImage, forKey: path)
                movie.imageData = data
                completion!(loadedImage)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func getCompletionResult(result: Result<MoviesResponse, Error>) {
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
        
        cell.tag = indexPath.row
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
    func loadImageView(cell: SearchMoviesTableViewCell, index: Int) {
        let movie = self.movies[index]
        
        guard let path = movie.movieResponse.posterPath else {
            cell.movieImageView.image = UIImage(named: "not_loaded_image.jpg")
            return
        }
        
        if let cachedImage = self.cache.object(forKey: NSString(string: path)) {
            cell.movieImageView.image = cachedImage
        } else {
            self.loadImage(movie: movie) { image in
                DispatchQueue.main.async {
                    if cell.tag == index {
                        cell.movieImageView.image = image
                    }
                }
            }
        }
    }
    
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
