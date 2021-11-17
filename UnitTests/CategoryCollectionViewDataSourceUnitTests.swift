//
//  CategoryCollectionViewDataSourceUnitTests.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class CategoryCollectionViewDataSourceUnitTests: XCTestCase {
    let dataSource = CategoryCollectionViewDataSource(movieCategoryPath: "")
    
    override func setUpWithError() throws {
        self.dataSource.movies.append(Movie(movieResponse: MovieResponse(id: 1, originalTitle: "title", title: "title", posterPath: "path", budget: "10000", overview: "overview", popularity: 23.7, releaseDate: "releaseDate", runtime: "runtime", genreIds: [1, 2, 3])))
        
        
        self.dataSource.filteredMovies.append(Movie(movieResponse: MovieResponse(id: 1, originalTitle: "title", title: "title", posterPath: "path", budget: "10000", overview: "overview", popularity: 23.7, releaseDate: "releaseDate", runtime: "runtime", genreIds: [1, 2, 3])))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetFilteredMovieValidIndex() throws {
        XCTAssertEqual("title", dataSource.getFilteredMovie(at: 0)?.movieResponse.title)
    }
    
    func testGetFilteredMovieInvalidIndex() throws {
        XCTAssertNil(dataSource.getFilteredMovie(at:1))
    }
    
    func testGetFilteredMovieNegativeIndex() throws {
        XCTAssertNil(dataSource.getFilteredMovie(at:-3))
    }
    
    func testGetMovieValidIndex() throws {
        XCTAssertEqual("title", dataSource.getMovie(at: 0)?.movieResponse.title)
    }
    
    func testGetMovieInvalidIndex() throws {
        XCTAssertNil(dataSource.getMovie(at:3))
    }
    
    func testGetMovieNegativeIndex() throws {
        XCTAssertNil(dataSource.getMovie(at:-6))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
