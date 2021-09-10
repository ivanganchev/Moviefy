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
}
