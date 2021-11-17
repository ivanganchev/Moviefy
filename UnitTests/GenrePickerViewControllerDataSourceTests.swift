//
//  GenrePickerViewControllerDataSourceTests.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class GenrePickerViewControllerDataSourceTests: XCTestCase {
    let dataSource = GenrePickerViewControllerDataSource()
    
    override func setUpWithError() throws {
        MoviesService.genres = [0:"Action",
                                1:"Comedy",
                                2:"Horror"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMovieValidIndex() throws {
        XCTAssertEqual("Comedy", self.dataSource.getGenre(at: 1))
    }
    
    func testGetMovieInvalidIndex() throws {
        XCTAssertNil(self.dataSource.getGenre(at:4))
    }
    
    func testGetMovieNegativeIndex() throws {
        XCTAssertNil(self.dataSource.getGenre(at:-18))
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
