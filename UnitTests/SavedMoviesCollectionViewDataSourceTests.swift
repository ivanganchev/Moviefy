//
//  SavedMoviesCollectionViewDataSourceTests.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class SavedMoviesCollectionViewDataSourceTests: XCTestCase {
    let dataSource = SavedMoviesCollectionViewDataSource()
    
    override func setUpWithError() throws {
        self.dataSource.savedFilteredMovies.append(MovieEntity(movie: Movie(movieResponse: MovieResponse(id: 1, originalTitle: "title", title: "title", posterPath: "path", budget: "10000", overview: "overview", popularity: 23.7, releaseDate: "releaseDate", runtime: "runtime", genreIds: [1, 2, 3]))))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMovieValidIndex() throws {
        XCTAssertEqual("title", self.dataSource.getSavedFilteredMovie(at: 0)?.title)
    }
    
    func testGetMovieInvalidIndex() throws {
        XCTAssertNil(self.dataSource.getSavedFilteredMovie(at:6))
    }
    
    func testGetMovieNegativeIndex() throws {
        XCTAssertNil(self.dataSource.getSavedFilteredMovie(at:-3))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
