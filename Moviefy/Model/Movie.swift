//
//  Movie.swift
//  Moviefy
//
//  Created by A-Team Intern on 9.09.21.
//

import Foundation

class Movie: Hashable {
    let movieResponse: MovieResponse
    var imageData: Data? = nil
    
    init(movieResponse: MovieResponse) {
        self.movieResponse = movieResponse
    }
    
    init(movieEntity: MovieEntity, imageData: Data) {
        self.movieResponse = MovieResponse(id: Int(movieEntity.id!), originalTitle: movieEntity.originalTitle, title: movieEntity.title, posterPath: movieEntity.posterPath, budget: movieEntity.budget, overview: movieEntity.overview, popularity: movieEntity.popularity, releaseDate: movieEntity.releaseDate, runtime: movieEntity.runtime, genreIds: Array(movieEntity.genreIds))
        self.imageData = imageData
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.movieResponse.id)
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.movieResponse.id == rhs.movieResponse.id
    }
}
