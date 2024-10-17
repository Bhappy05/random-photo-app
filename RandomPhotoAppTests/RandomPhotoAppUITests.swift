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
    lazy var tabBar: XCUIElement = {
        return app.tabBars.firstMatch
    }()

    lazy var mainVC: XCUIElement = {
        return app.otherElements["MainVCIdentifier"]
    }()

    lazy var catsVC: XCUIElement = {
        return app.otherElements["CatsVCIdentifier"]
    }()

    lazy var dogsVC: XCUIElement = {
        return app.otherElements["DogsVCIdentifier"]
    }()
    
    lazy var mainImageView: XCUIElement = {
        return app.images["MainImageViewIdentifier"]
    }()
    
    lazy var catsImageView: XCUIElement = {
        return app.images["CatsImageViewIdentifier"]
    }()
    
    lazy var dogsImageView: XCUIElement = {
        return app.images["DogsImageViewIdentifier"]
    }()

    lazy var buttonAnyPhoto: XCUIElement = {
        return app.buttons["RandomPhotoButtonIdentifier"]
    }()

    lazy var buttonCat: XCUIElement = {
        return app.buttons["RandomCatButtonIdentifier"]
    }()

    lazy var buttonDog: XCUIElement = {
        return app.buttons["RandomDogButtonIdentifier"]
    }()
    
    lazy var imageLoader: XCUIElement = {
        return app.activityIndicators["ImageLoaderIdentifier"]
    }()
    
    override func setUpWithError() throws {
        MockURLProtocol.responseData = nil // Reset mock data
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        MockURLProtocol.responseData = nil // Reset mock data
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
    
    func testAlerts() {
        app.launchEnvironment["UITestMode"] = "true" // Set environment variable to indicate the test mode
        app.launch()
        let alert = app.alerts["ErrorAlertIdentifier"]
        let alertLabel = app.staticTexts["Something went wrong"]
        
        
        //
        // Asserts for MainViewController
        //
        
        buttonAnyPhoto.tap()
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alertLabel.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alertLabel.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alertLabel.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
    }
    
    func testFullFlow() { // Integration test for all screens
        let bottomSheet = app.otherElements["BottomSheetIdentifier"]
        
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
        XCTAssertEqual(catsViewLabel.label, "Random Cat Photo", "The title label should display 'Random Cat Photo'.")
        XCTAssertEqual(buttonCat.label, "New Random Cat", "The name of the button 'New Random Cat' is incorrect")
        XCTAssertTrue(catsImageView.exists, "Cats image view does not exists")
        
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertEqual(dogsViewLabel.label, "Random Dog Photo", "The title label should display 'Random Dog Photo'.")
        XCTAssertEqual(buttonDog.label, "New Random Dog", "The name of the button 'New Random Dog' is incorrect")
        XCTAssertTrue(dogsImageView.exists, "Dogs image view does not exists")
        
        tabBar.buttons["Any Photo"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main VC did not appear") // Assert to make sure that we are on the main VC
    }
    
    func testDeepLinkToMainViewController() throws {
            app.launchArguments = ["-deeplink", "randomphotoapp://"] // Provide the deep link URL as a launch argument
            XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main View did not appear on deep link") // Wait for the main view to appear
        }
    
    func testLaunchPerformance() throws { // This measures how long it takes to launch application.
        if #available(macOS 10.15, iOS 16.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testLoaders() {
        let predicate = NSPredicate(format: "label == 'ImageLoaded'")
        let mainViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: mainImageView)
        let catsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: catsImageView)
        let dogsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: dogsImageView)
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        XCTAssertTrue(imageLoader.isHittable, "Loader did not appear")
        
        var result = XCTWaiter().wait(for: [mainViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        XCTAssertTrue(imageLoader.accessibilityTraits.isEmpty, "Loader did not disappear after image loaded")
        tabBar.buttons["Cats"].tap()
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(imageLoader.waitForExistence(timeout: 3), "Loader did not appear")
        result = XCTWaiter().wait(for: [catsViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        XCTAssertTrue(imageLoader.accessibilityTraits.isEmpty, "Loader did not disappear after image loaded")
        tabBar.buttons["Dogs"].tap()
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(imageLoader.waitForExistence(timeout: 3), "Loader did not appear")
        result = XCTWaiter().wait(for: [dogsViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        XCTAssertTrue(imageLoader.accessibilityTraits.isEmpty, "Loader did not disappear after image loaded")
    }
}
