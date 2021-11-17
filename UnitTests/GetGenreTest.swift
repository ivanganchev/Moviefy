//
//  GetGenreTest.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class GetGenreTest: XCTestCase {
    let dataSource = GenreChipsCollectionViewDataSource()
    
    override func setUpWithError() throws {
        dataSource.addSelectedGenre(genre: "Action")
        dataSource.addSelectedGenre(genre: "Adventure")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetGenreValidIndex() throws {
        XCTAssertEqual("Action", self.dataSource.getGenre(at: 0))
    }
    
    func testGetGenreNegativeIndex() throws {
        XCTAssertNil(self.dataSource.getGenre(at: -1))
    }
    
    func testGetGenreInvalidIndex() throws {
        XCTAssertNil(self.dataSource.getGenre(at: 3))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
