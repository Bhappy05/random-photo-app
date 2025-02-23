//
//  RandomPhotoAppUITests.swift
//  RandomPhotoAppUITests
//
//  Created by Dionis on 25.08.24.
//

import XCTest

final class RandomPhotoAppUITests: XCTestCase {

    var app: XCUIApplication!
    let mainView = MainPageObject()
    let catsView = CatsPageObject()
    let dogsView = DogsPageObject()

    lazy var mainImageView: XCUIElement = {
        return app.images["MainImageViewIdentifier"]
    }()
    
    lazy var catsImageView: XCUIElement = {
        return app.images["CatsImageViewIdentifier"]
    }()
    
    lazy var dogsImageView: XCUIElement = {
        return app.images["DogsImageViewIdentifier"]
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
        let tabBar: XCUIElement = {
            return app.tabBars.firstMatch
        }()
        
        XCTAssertTrue(tabBar.buttons["Any Photo"].exists, "Tab Bar button 'Any Photo' does not exist")
        XCTAssertTrue(tabBar.buttons["Cats"].exists, "Tab Bar button 'Cats' does not exist")
        XCTAssertTrue(tabBar.buttons["Dogs"].exists, "Tab Bar button 'Dogs' does not exist")
        
        tabBar.buttons["Cats"].tap()
        catsView.checkThatScreenIsOpened()
        
        tabBar.buttons["Dogs"].tap()
        dogsView.checkThatScreenIsOpened()
        
        tabBar.buttons["Any Photo"].tap()
        mainView.checkThatScreenIsOpened()
    }
    
    func testAlerts() {
        app.terminate()
        app.launchEnvironment["UITestModeError"] = "true" // Set environment variable to indicate the test mode for mocking image
        app.launch()
        
        //
        // Asserts for MainViewController
        //
        
        mainView.buttonAnyPhoto.tap()
        mainView.checkAlert()
        mainView.alert.buttons["OK"].tap()
        mainView.checkThatScreenIsOpened()
        mainView.tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        catsView.checkThatScreenIsOpened()
        catsView.checkAlert()
        catsView.alert.buttons["OK"].tap()
        catsView.checkThatScreenIsOpened()
        catsView.tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        dogsView.checkThatScreenIsOpened()
        dogsView.checkAlert()
        dogsView.alert.buttons["OK"].tap()
        dogsView.checkThatScreenIsOpened()
    }
    
    func testFullFlow() { // Integration test for all screens
        //
        // Asserts for MainViewController
        //
        
        mainView.checkThatScreenIsOpened()
        mainView.checkLabel()
        mainView.checkImageView()
        mainView.checkNewPhotoButton()
        mainView.checkSaveButton()
        mainView.checkInfoButton()
        mainView.infoButton.tap()
        mainView.checkBottomSheet()
        mainView.bottomSheet.swipeDown()
        mainView.tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        catsView.checkThatScreenIsOpened()
        catsView.checkLabel()
        catsView.checkImageView()
        catsView.checkCatButton()
        catsView.checkSaveButton()
        catsView.tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        dogsView.checkThatScreenIsOpened()
        dogsView.checkLabel()
        dogsView.checkImageView()
        dogsView.checkDogButton()
        dogsView.checkSaveButton()
        dogsView.tabBar.buttons["Any Photo"].tap()
        mainView.checkThatScreenIsOpened()
    }
    
    func testDeepLinkToMainViewController() throws {
        
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoapp://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with provided arguments
        
        mainView.checkThatScreenIsOpened()
    }
    
    func testDeepLinkToCatsViewController() throws {
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoappcats://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with the provided arguments
        
        catsView.checkThatScreenIsOpened()
    }
    
    func testDeepLinkToDogsViewController() throws {
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoappdogs://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with the provided arguments
        
        dogsView.checkThatScreenIsOpened()
    }
    
    func testLoaders() {
        let predicate = NSPredicate(format: "label == 'ImageLoaded'")
        let mainViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: mainImageView)
        let catsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: catsImageView)
        let dogsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: dogsImageView)
        
        app.terminate()
        app.launchEnvironment["UITestModeSuccess"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
        
        mainView.checkThatScreenIsOpened()
        mainView.checkLoader()
        
        var result = XCTWaiter().wait(for: [mainViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        mainView.checkThatLoaderGone()
        
        mainView.tabBar.buttons["Cats"].tap()
        
        catsView.checkThatScreenIsOpened()
        catsView.checkLoader()
        result = XCTWaiter().wait(for: [catsViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        catsView.checkThatLoaderGone()
        
        catsView.tabBar.buttons["Dogs"].tap()
        
        dogsView.checkThatScreenIsOpened()
        dogsView.checkLoader()
        result = XCTWaiter().wait(for: [dogsViewExpectation], timeout: 15)
        XCTAssertEqual(result, .completed, "Image did not load in time")
        dogsView.checkThatLoaderGone()
    }
    
    func testImageSavingSuccess() {
        app.terminate()
        app.launchEnvironment["UITestModeSuccess"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
        
        //
        // Asserts for MainViewController
        //
        
        mainView.checkThatScreenIsOpened()
        mainView.checkSaveButton()
        mainView.buttonSaveImage.tap()
        mainView.checkToastSuccess()
        mainView.checkThatTabBarExists()
        mainView.tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        catsView.checkThatScreenIsOpened()
        catsView.checkSaveButton()
        catsView.buttonSaveImage.tap()
        catsView.checkToastSuccess()
        catsView.checkThatTabBarExists()
        catsView.tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        dogsView.checkThatScreenIsOpened()
        dogsView.checkSaveButton()
        dogsView.buttonSaveImage.tap()
        dogsView.checkToastSuccess()
    }
    
    func testImageSavingError() {
        app.terminate()
        app.launchEnvironment["UITestModeError"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
    
        //
        // Asserts for MainViewController
        //
        
        mainView.checkThatScreenIsOpened()
        mainView.checkSaveButton()
        mainView.buttonSaveImage.tap()
        mainView.checkToastNoPhoto()
        mainView.checkThatTabBarExists()
        mainView.tabBar.buttons["Cats"].tap()
      
        //
        // Asserts for CatsViewController
        //
        
        catsView.checkThatScreenIsOpened()
        catsView.checkSaveButton()
        catsView.buttonSaveImage.tap()
        catsView.checkToastNoPhoto()
        catsView.checkThatTabBarExists()
        catsView.tabBar.buttons["Dogs"].tap()
     
        //
        // Asserts for DogsViewController
        //
        
        dogsView.checkThatScreenIsOpened()
        dogsView.checkSaveButton()
        dogsView.buttonSaveImage.tap()
        dogsView.checkToastNoPhoto()
    }
}
