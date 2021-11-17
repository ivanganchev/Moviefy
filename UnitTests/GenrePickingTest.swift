//
//  GenrePickingTest.swift
//  UnitTests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest
@testable import Moviefy

class GenrePickingTest: XCTestCase {
    var selectedGenres = [String]()
    var allGenres = [String]()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRowWhenSelectionIsUnavailable() throws {
        selectedGenres = ["Drama", "Action"]
        allGenres = ["Adventure", "Drama", "Action", "Horror"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 2, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 3)
    }
    
    func testRowWhenLastIndexSelectionIsUnavailable() throws {
        selectedGenres = ["Horror"]
        allGenres = ["Adventure", "Drama", "Action", "Horror"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 3, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 2)
    }
    
    func testRowWhenSelectionAndRowBeneathAreUnavailable() throws {
        selectedGenres = ["Drama", "Action"]
        allGenres = ["Adventure", "Drama", "Action", "Horror"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 1, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 0)
    }
    
    func testRowWhenThereAreNoSelected() throws {
        selectedGenres = []
        allGenres = ["Adventure", "Drama", "Action", "Horror"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 1, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 1)
    }
    
    func testRowWhenSelectionIsMiddleInThreeUnavailable() throws {
        selectedGenres = ["Drama", "Action", "Horror"]
        allGenres = ["Adventure", "Drama", "Action", "Horror", "Comedy"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 2, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 0)
    }
    
    func testRowWhenEveryRowIsSelected() throws {
        selectedGenres = ["Adventure", "Drama", "Action", "Horror", "Comedy"]
        allGenres = ["Adventure", "Drama", "Action", "Horror", "Comedy"]
        
        let index = GenrePickerHelper.getUnselectedGenre(rowNumber: 2, allGenres: allGenres, selectedGenres: selectedGenres)
    
        XCTAssertEqual(index, 0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

