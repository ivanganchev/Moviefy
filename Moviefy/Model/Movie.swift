//
//  Movie.swift
//  Moviefy
//
//  Created by A-Team Intern on 9.09.21.
//

import UIKit

class Movie: Hashable {
    let movieResponse: MovieResponse
    lazy var genres: [String] = (movieResponse.genreIds ?? []).compactMap { id -> String? in
        MoviesService.genres[id]
    }
    
    init(movieResponse: MovieResponse) {
        self.movieResponse = movieResponse
    }
    
    init(movieEntity: MovieEntity) {
        self.movieResponse = MovieResponse(
            id: Int(movieEntity.id!),
            originalTitle: movieEntity.originalTitle,
            title: movieEntity.title,
            posterPath: movieEntity.posterPath,
            budget: movieEntity.budget,
            overview: movieEntity.overview,
            popularity: movieEntity.popularity,
            releaseDate: movieEntity.releaseDate,
            runtime: movieEntity.runtime,
            genreIds: Array(movieEntity.genreIds)
        )
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
