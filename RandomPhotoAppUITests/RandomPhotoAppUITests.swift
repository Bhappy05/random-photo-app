//
//  RandomPhotoAppUITests.swift
//  RandomPhotoAppUITests
//
//  Created by Dionis on 25.08.24.
//

import XCTest

final class RandomPhotoAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    // Properties for common UI elements
    var tabBar: XCUIElement!
    var mainVC: XCUIElement!
    var catsVC: XCUIElement!
    var dogsVC: XCUIElement!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Initialize common UI elements
        tabBar = app.tabBars.firstMatch
        mainVC = app.otherElements["MainVCIdentifier"]
        catsVC = app.otherElements["CatsVCIdentifier"]
        dogsVC = app.otherElements["DogsVCIdentifier"]
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testTabBarComponents() {
        XCTAssertTrue(tabBar.buttons["Any Photo"].exists, "Tab Bar button 'Any Photo' does not exist")
        XCTAssertTrue(tabBar.buttons["Cats"].exists, "Tab Bar button 'Cats' does not exist")
        XCTAssertTrue(tabBar.buttons["Dogs"].exists, "Tab Bar button 'Dogs' does not exist")
        
        tabBar.buttons["Cats"].tap()
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        
        tabBar.buttons["Dogs"].tap()
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        
        tabBar.buttons["Any Photo"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
    }
    
    func testFullFlow() { // Integration test for all screens
        let bottomSheet = app.otherElements["BottomSheetIdentifier"]
        
        let mainImageView = app.images["MainImageViewIdentifier"]
        let catsImageView = app.images["CatsImageViewIdentifier"]
        let dogsImageView = app.images["DogsImageViewIdentifier"]
        
        
        let buttonAnyPhoto = app.buttons["RandomPhotoButtonIdentifier"]
        let buttonCat = app.buttons["RandomCatButtonIdentifier"]
        let buttonDog = app.buttons["RandomDogButtonIdentifier"]
        let infoButton = app.buttons["InfoButtonIdentifier"]
        
        let mainViewLabel = app.staticTexts["Random Photo"]
        let catsViewLabel = app.staticTexts["Random Cat Photo"]
        let dogsViewLabel = app.staticTexts["Random Dog Photo"]
        let infoText = app.staticTexts["I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners."]
        
        //
        // Asserts for MainViewController
        //
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        XCTAssertEqual(mainViewLabel.label, "Random Photo", "The title label should display 'Random Photo'.")
        XCTAssertEqual(buttonAnyPhoto.label, "New Random Photo", "The name of the button 'New Random Photo' is incorrect")
        XCTAssertTrue(mainImageView.exists, "Main image view does not exists")
        
        XCTAssertTrue(infoButton.exists, "Info button does not exist")
        infoButton.tap()
        XCTAssertTrue(bottomSheet.waitForExistence(timeout: 2), "Bottom sheet does not exists")
        XCTAssertEqual(infoText.label, "I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners.", "Info text is incorrect")
        bottomSheet.swipeDown()
        
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertEqual(catsViewLabel.label, "Random Cat Photo", "The title label should display 'Random Photo'.")
        XCTAssertEqual(buttonCat.label, "New Random Cat", "The name of the button 'New Random Cat' is incorrect")
        XCTAssertTrue(catsImageView.exists, "Main image view does not exists")
        
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertEqual(dogsViewLabel.label, "Random Dog Photo", "The title label should display 'Random Photo'.")
        XCTAssertEqual(buttonDog.label, "New Random Dog", "The name of the button 'New Random Dog' is incorrect")
        XCTAssertTrue(dogsImageView.exists, "Main image view does not exists")
        
        tabBar.buttons["Any Photo"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main VC did not appear") // Assert to make sure that we are on the main VC
    }
    
    func testDeepLinkToMainViewController() throws {
            app.launchArguments = ["-deeplink", "randomphotoapp://"] // Provide the deep link URL as a launch argument
            XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main View did not appear on deep link") // Wait for the main view to appear
        }
    
    func testLaunchPerformance() throws { // This measures how long it takes to launch application.
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
