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
    
    lazy var buttonSaveImage: XCUIElement = {
        return app.buttons["SaveButtonIdentifier"]
    }()
    
    lazy var imageLoader: XCUIElement = {
        return app.activityIndicators["ImageLoaderIdentifier"]
    }()
    
    lazy var alert: XCUIElement = {
        return app.alerts["ErrorAlertIdentifier"]
    }()
    
    lazy var toast: XCUIElement = {
        return app.alerts["ToastIdentifier"]
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
        app.terminate()
        app.launchEnvironment["UITestModeError"] = "true" // Set environment variable to indicate the test mode for mocking image
        app.launch()
        
        //
        // Asserts for MainViewController
        //
        
        buttonAnyPhoto.tap()
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alert.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alert.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        XCTAssertEqual(alert.label, "Something went wrong", "The alert label should display 'Something went wrong'")
        alert.buttons["OK"].tap()
    }
    
    func testFullFlow() { // Integration test for all screens
        let bottomSheet = app.otherElements["BottomSheetIdentifier"]
        
        let infoButton = app.buttons["InfoButtonIdentifier"]
        
        let mainViewLabel = app.staticTexts["RandomPhotoLabelIdentifier"]
        let catsViewLabel = app.staticTexts["RandomCatLabelIdentifier"]
        let dogsViewLabel = app.staticTexts["RandomDogLabelIdentifier"]
        let infoTextLabel = app.staticTexts["BottomLabelIdentifier"]
        
        //
        // Asserts for MainViewController
        //
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        XCTAssertTrue(mainViewLabel.exists, "The label with identifier 'RandomPhotoLabelIdentifier' should exist.")
        XCTAssertEqual(mainViewLabel.label, "Random Photo", "The title label should display 'Random Photo'.")
        XCTAssertEqual(buttonAnyPhoto.label, "New Photo", "The name of the button 'New Random Photo' is incorrect")
        XCTAssertTrue(mainImageView.exists, "Main image view does not exists")
        
        XCTAssertTrue(infoButton.exists, "Info button does not exist")
        infoButton.tap()
        XCTAssertTrue(bottomSheet.waitForExistence(timeout: 2), "Bottom sheet does not exists")
        XCTAssertTrue(infoTextLabel.exists, "The label with identifier 'BottomLabelIdentifier' should exist.")
        XCTAssertEqual(infoTextLabel.label, "I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners.", "Info text is incorrect")
        bottomSheet.swipeDown()
        
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(catsViewLabel.exists, "The label with identifier 'RandomCatLabelIdentifier' should exist.")
        XCTAssertEqual(catsViewLabel.label, "Random Cat Photo", "The title label should display 'Random Cat Photo'.")
        XCTAssertEqual(buttonCat.label, "New Cat", "The name of the button 'New Random Cat' is incorrect")
        XCTAssertTrue(catsImageView.exists, "Cats image view does not exists")
        
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(dogsViewLabel.exists, "The label with identifier 'RandomDogLabelIdentifier' should exist.")
        XCTAssertEqual(dogsViewLabel.label, "Random Dog Photo", "The title label should display 'Random Dog Photo'.")
        XCTAssertEqual(buttonDog.label, "New Dog", "The name of the button 'New Random Dog' is incorrect")
        XCTAssertTrue(dogsImageView.exists, "Dogs image view does not exists")
        
        tabBar.buttons["Any Photo"].tap()
        XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main VC did not appear") // Assert to make sure that we are on the main VC
    }
    
    func testDeepLinkToMainViewController() throws {
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoapp://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with provided arguments
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 5), "Main View did not appear on deep link") // Check if it is the main view controller
    }
    
    func testDeepLinkToCatsViewController() throws {
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoappcats://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with the provided arguments
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 5), "Cats View did not appear on deep link") // Check if it is the cats view controller
    }
    
    func testDeepLinkToDogsViewController() throws {
        app.terminate()
        app.launchArguments = ["-deeplink", "randomphotoappdogs://"] // Provides the deep link URL as a launch argument
        app.launch() // Launching the app with the provided arguments
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 5), "Dogs View did not appear on deep link") // Check if it is the dogs view controller
    }
    
    func testLoaders() {
        let predicate = NSPredicate(format: "label == 'ImageLoaded'")
        let mainViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: mainImageView)
        let catsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: catsImageView)
        let dogsViewExpectation = XCTNSPredicateExpectation(predicate: predicate, object: dogsImageView)
        
        app.terminate()
        app.launchEnvironment["UITestModeSuccess"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
        
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
    
    func testImageSavingSuccess() {
        app.terminate()
        app.launchEnvironment["UITestModeSuccess"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
        
        //
        // Asserts for MainViewController
        //
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        buttonAnyPhoto.tap()
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast after saving image did not appear")
        XCTAssertEqual(toast.label, "Image saved succesfully", "Label on the toast should dispaly 'Image saved succesfully'")
        
        XCTAssertTrue(tabBar.buttons["Cats"].waitForExistence(timeout: 3), "Tabbar did not appear")
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast after saving image did not appear")
        XCTAssertEqual(toast.label, "Image saved succesfully", "Label on the toast should dispaly 'Image saved succesfully'")
        
        XCTAssertTrue(tabBar.buttons["Dogs"].waitForExistence(timeout: 3), "Tabbar did not appear")
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast after saving image did not appear")
        XCTAssertEqual(toast.label, "Image saved succesfully", "Label on the toast should dispaly 'Image saved succesfully'")
    }
    
    func testImageSavingError() {
        app.terminate()
        app.launchEnvironment["UITestModeError"] = "true" // Setting environment variable to indicate the test mode for mocking image
        app.launch()
    
        //
        // Asserts for MainViewController
        //
        
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonAnyPhoto.tap()
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        alert.buttons["OK"].tap()
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast did not appear")
        XCTAssertEqual(toast.label, "Error: No photo available for download", "Label on the toast should dispaly 'Error: No photo available for download'")
        
        XCTAssertTrue(tabBar.buttons["Cats"].waitForExistence(timeout: 3), "Tabbar did not appear")
        tabBar.buttons["Cats"].tap()
        
        //
        // Asserts for CatsViewController
        //
        
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonCat.tap()
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        alert.buttons["OK"].tap()
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast did not appear")
        XCTAssertEqual(toast.label, "Error: No photo available for download", "Label on the toast should dispaly 'Error: No photo available for download'")
        
        XCTAssertTrue(tabBar.buttons["Dogs"].waitForExistence(timeout: 3), "Tabbar did not appear")
        tabBar.buttons["Dogs"].tap()
        
        //
        // Asserts for DogsViewController
        //
        
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
        XCTAssertTrue(buttonSaveImage.exists, "Button for saving image did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "Label on the button should dispaly 'Save Photo'")
        buttonDog.tap()
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Error alert did not appear")
        alert.buttons["OK"].tap()
        buttonSaveImage.tap()
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast did not appear")
        XCTAssertEqual(toast.label, "Error: No photo available for download", "Label on the toast should dispaly 'Error: No photo available for download'")
    }
}
