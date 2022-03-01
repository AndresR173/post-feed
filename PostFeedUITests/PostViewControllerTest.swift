//
//  PostViewControllerTest.swift
//  PostFeedUITests
//
//  Created by Andres Rojas on 1/03/22.
//

import XCTest

class PostViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testActionButtonsShouldDeleteAndRefreshList() throws {

        let app = XCUIApplication()
        let navigationbarNavigationBar = app.navigationBars["navigationBar"]
        let deleteButton = navigationbarNavigationBar.buttons["posts.deleteButton"]
        XCTAssert(deleteButton.waitForExistence(timeout: 1))

        let cell = app.tables["posts.tableView"].staticTexts["title"]
        XCTAssert(cell.waitForExistence(timeout: 1))

        deleteButton.tap()

        app.sheets["Delete"].scrollViews.otherElements.buttons["delete.alertAction"].tap()

        XCTAssert(!cell.waitForExistence(timeout: 1))

        let refreshButton = navigationbarNavigationBar.buttons["posts.refreshButton"]

        refreshButton.tap()

        XCTAssert(cell.waitForExistence(timeout: 1))
    }

    func testShouldOpenPostDetailsAfterTappingACell() {
        let app = XCUIApplication()

        let cell = app.tables["posts.tableView"].staticTexts["title"]
        XCTAssert(cell.waitForExistence(timeout: 1))

        cell.tap()

        let postdetailsTableviewTable = XCUIApplication().tables["postDetails.tableView"]
        let label = postdetailsTableviewTable.staticTexts["postDetails.title"]
        XCTAssert(label.waitForExistence(timeout: 1))

    }

}
