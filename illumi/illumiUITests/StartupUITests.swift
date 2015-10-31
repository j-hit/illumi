//
//  illumiUITests.swift
//  illumiUITests
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
@testable import illumi

class startupUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func testFirstTimeLaunch() {
        let app = XCUIApplication()
        
        let contentSearchView = app.otherElements["Content Search"]
        let requiredSettingsView = app.otherElements["Required Settings"]
        
        expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: app, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        
        if(requiredSettingsView.exists){
            let doneButton = app.buttons["Done"]
            app.switches["Activate notifications"].tap()
            doneButton.tap()
            app.switches["Activate location"].tap()
            doneButton.tap()
            
            contentSearchView.tap()
            
            XCTAssertTrue(contentSearchView.exists, "Now the content search view should still exist")
            XCTAssertFalse(requiredSettingsView.exists, "The required settings view should no longer exist")
        }else if(contentSearchView.exists){
            XCTAssertFalse(requiredSettingsView.exists)
        }else{
            XCTFail("One of the two view from above should be shown. Why is this not the case")
        }
    }
}
