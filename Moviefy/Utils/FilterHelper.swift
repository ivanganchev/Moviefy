//
//  Filter.swift
//  Moviefy
//
//  Created by A-Team Intern on 20.10.21.
//

import Foundation

class FilterHelper {
    static func filterByGenres(movies: [Movie], selectedGenres: [String], allGenres: [Int: String]) -> [Movie] {
        var newFilteredMovies: [Movie] = movies
        
        selectedGenres.forEach({ genre in
            var tempArr: [Movie] = []
            newFilteredMovies.forEach { movie in
                if let genres = movie.movieResponse.genreIds,
                   let id = allGenres.first(where: {$0.value == genre})?.key,
                   genres.contains(id) {
                    tempArr.append(movie)
                }
            }
            newFilteredMovies = tempArr
        })
    
        return newFilteredMovies
    }
}
