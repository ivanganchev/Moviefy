//
//  Movie.swift
//  Moviefy
//
//  Created by A-Team Intern on 9.09.21.
//

import Foundation

class Movie {
    let movieResponse: MovieResponse
    var imageData: Data? = nil
    
    init(movieResponse: MovieResponse) {
        self.movieResponse = movieResponse
    }
    
    init(movieEntity: MovieEntity, imageData: Data) {
        self.movieResponse = MovieResponse(originalTitle: movieEntity.originalTitle, title: movieEntity.title, posterPath:  movieEntity.posterPath, budget: movieEntity.budget, overview: movieEntity.overview, popularity: movieEntity.popularity, releaseDate: movieEntity.releaseDate, runtime: movieEntity.runtime, genreIds: Array(movieEntity.genreIds))
        self.imageData = imageData
    }
}
