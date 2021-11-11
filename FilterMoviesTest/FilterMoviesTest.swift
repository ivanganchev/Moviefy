//
//  FilterMoviesTest.swift
//  FilterMoviesTest
//
//  Created by A-Team Intern on 20.10.21.
//

import XCTest
@testable import Moviefy

class FilterMoviesTest: XCTestCase {
    var movies = [Movie]()
    var allGenres = [
        10770: "Western",
        53: "Comedy",
        10752: "Horror",
        9648: "Action",
        878: "Adventure",
        37: "Thriller",
        12: "Drama",
        80: "Romantic",
        14: "Fantasy"
    ]
    
    override func setUpWithError() throws {
        movies.append(Movie(movieResponse: MovieResponse(id: 0, originalTitle: "Movie1", title: "Movie1", posterPath: "fdsfsdfsdfsd", budget: "10000", overview: "", popularity: 31.13, releaseDate: "", runtime: "", genreIds: [10770, 53, 10752])))
        movies.append(Movie(movieResponse: MovieResponse(id: 0, originalTitle: "Movie1", title: "Movie1", posterPath: "fdsfsdfsdfsd", budget: "10000", overview: "", popularity: 31.13, releaseDate: "", runtime: "", genreIds: [10770, 9648, 878])))
        movies.append(Movie(movieResponse: MovieResponse(id: 0, originalTitle: "Movie1", title: "Movie1", posterPath: "fdsfsdfsdfsd", budget: "10000", overview: "", popularity: 31.13, releaseDate: "", runtime: "", genreIds: [53, 37, 10752])))
        movies.append(Movie(movieResponse: MovieResponse(id: 0, originalTitle: "Movie1", title: "Movie1", posterPath: "fdsfsdfsdfsd", budget: "10000", overview: "", popularity: 31.13, releaseDate: "", runtime: "", genreIds: [12, 53, 80])))
        movies.append(Movie(movieResponse: MovieResponse(id: 0, originalTitle: "Movie1", title: "Movie1", posterPath: "fdsfsdfsdfsd", budget: "10000", overview: "", popularity: 31.13, releaseDate: "", runtime: "", genreIds: [9648, 14, 878])))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilterWithOneGenre() throws {
        let filteredMovies = FilterHelper.filterByGenres(movies: movies, selectedGenres: ["Horror"], allGenres: allGenres)
        
        XCTAssertEqual(2, filteredMovies.count)
    }
    
    func testFilterWithMultipleGenres() throws {
        let filteredMovies = FilterHelper.filterByGenres(movies: movies, selectedGenres: ["Western", "Action", "Adventure"], allGenres: allGenres)
        
        XCTAssertEqual(1, filteredMovies.count)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
