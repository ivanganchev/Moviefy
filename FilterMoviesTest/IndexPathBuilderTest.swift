//
//  sdfs.swift
//  FilterMoviesTest
//
//  Created by A-Team Intern on 10.11.21.
//

import XCTest
@testable import Moviefy

class IndexPathBuilderTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndexPathsOfHiddenContent() throws {
        XCTAssertEqual(3, IndexPathBuilder.getIndexPathForHiddenContent(oldCount: 2, newCount: 5).count)
    }
    
    func testIndexPathRowForFirstHiddenItem() throws {
        let row = IndexPathBuilder.getIndexPathForHiddenContent(oldCount: 5, newCount: 7)[0].row
        
        XCTAssertEqual(5, row)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
