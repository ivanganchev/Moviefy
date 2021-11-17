//
//  MoviefyUITests.swift
//  MoviefyUITests
//
//  Created by A-Team Intern on 17.11.21.
//

import XCTest

class MoviefyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenreChipsText() throws {
        let app = XCUIApplication()
        app.launch()

        app.tables.children(matching: .button).matching(identifier: "See all").element(boundBy: 0).staticTexts["See all"].tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Add filter"]/*[[".buttons[\"Add filter\"].staticTexts[\"Add filter\"]",".staticTexts[\"Add filter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        app.buttons["add"].tap()
        doneButton.tap()
        
        let collectionViewsQuery = app.collectionViews.matching(identifier: "genreChipsCollectionView")
        
        XCTAssertEqual("Action", collectionViewsQuery.cells.element(boundBy: 0).children(matching: .any).matching(identifier: "genreLabel").firstMatch.label)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
