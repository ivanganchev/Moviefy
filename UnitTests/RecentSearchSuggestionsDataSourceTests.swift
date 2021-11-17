//
//  RecentSearchSuggestionsDataSourceTests.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class RecentSearchSuggestionsDataSourceTests: XCTestCase {
    let dataSource = RecentSearchSuggestionsDataSource()
    
    override func setUpWithError() throws {
        self.dataSource.suggestions.append(SuggestionEntity(suggestion: "Suggestion"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMovieValidIndex() throws {
        XCTAssertEqual("Suggestion", self.dataSource.getSuggestion(at: 0)?.suggestion)
    }
    
    func testGetMovieInvalidIndex() throws {
        XCTAssertNil(self.dataSource.getSuggestion(at:1))
    }
    
    func testGetMovieNegativeIndex() throws {
        XCTAssertNil(self.dataSource.getSuggestion(at:-1))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
