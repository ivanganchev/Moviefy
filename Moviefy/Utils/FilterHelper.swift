//
//  Filter.swift
//  Moviefy
//
//  Created by A-Team Intern on 20.10.21.
//

import Foundation

class FilterHelper {
    static func getMoviesByGenres(movies: [Movie], selectedGenres: [String], allGenres: [Int: String]?) -> [Movie] {
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
    
        return newFilteredMovies
    }
}
