//
//  MoviesCollectionViewDataSourceTests.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class MoviesCollectionViewDataSourceTests: XCTestCase {
    let dataSource = MoviesCollectionViewDataSource()
    
    override func setUpWithError() throws {
        self.dataSource.movies.append(Movie(movieResponse: MovieResponse(id: 1, originalTitle: "title", title: "title", posterPath: "path", budget: "10000", overview: "overview", popularity: 23.7, releaseDate: "releaseDate", runtime: "runtime", genreIds: [1, 2, 3])))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMovieValidIndex() throws {
        XCTAssertEqual("title", self.dataSource.getMovie(at: 0)?.movieResponse.title)
    }
    
    func testGetMovieInvalidIndex() throws {
        XCTAssertNil(self.dataSource.getMovie(at:1))
    }
    
    func testGetMovieNegativeIndex() throws {
        XCTAssertNil(self.dataSource.getMovie(at:-2))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
