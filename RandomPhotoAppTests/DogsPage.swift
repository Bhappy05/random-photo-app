//
//  DogsPage.swift
//  RandomPhotoAppUITests
//
//  Created by Dionis on 23.02.25.
//

import XCTest

final class DogsPageObject: XCTestCase {
    let app: XCUIApplication = XCUIApplication()
    
    // Mark: - Elements
    
    lazy var dogsVC: XCUIElement = {
        return app.otherElements["DogsVCIdentifier"]
    }()
    
    lazy var dogsImageView: XCUIElement = {
        return app.images["DogsImageViewIdentifier"]
    }()
    
    lazy var loader: XCUIElement = {
        return app.activityIndicators["ImageLoaderIdentifier"]
    }()
    
    lazy var buttonDog: XCUIElement = {
        return app.buttons["RandomDogButtonIdentifier"]
    }()
    
    lazy var buttonSaveImage: XCUIElement = {
        return app.buttons["SaveButtonIdentifier"]
    }()
    
    lazy var alert: XCUIElement = {
        return app.alerts["ErrorAlertIdentifier"]
    }()
    
    lazy var toast: XCUIElement = {
        return app.alerts["ToastIdentifier"]
    }()
    
    lazy var tabBar: XCUIElement = {
        return app.tabBars.firstMatch
    }()
    
    lazy var mainTab: XCUIElement = {
        return tabBar.buttons["Any photo"]
    }()
    
    lazy var catsTab: XCUIElement = {
        return tabBar.buttons["Cats"]
    }()
    
    // Mark: - Actions
    func tapLoadButton() {
        print("Tap 'New Dog' button")
        buttonDog.tap()
    }
    
    func tapSaveButton() {
        print("Tap 'Save Photo' button")
        buttonSaveImage.tap()
    }
    
    func tapMainTab() {
        print("Tap Main tab")
        mainTab.tap()
    }
    
    func tapDogsTab() {
        print("Tap Cats tab")
        catsTab.tap()
    }
    
    // Mark: - Asserts
    
    func checkImageView() {
        print("Check that image view exists")
        XCTAssertTrue(dogsImageView.waitForExistence(timeout: 3), "Dogs image view does not exists")
    }
    
    func checkLoader() {
        print("Check that loader is visible")
        XCTAssertTrue(loader.isHittable, "Loader did not appear")
    }
    
    func checkThatLoaderGone() {
        print("Check that loader is gone")
        XCTAssertTrue(loader.accessibilityTraits.isEmpty, "Loader did not disappear after image loaded")
    }
    
    func checkToastSuccess() {
        print("Check that toast is displayed")
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast after saving image did not appear")
        XCTAssertEqual(toast.label, "Image saved succesfully", "Label on the toast should display 'Image saved succesfully'")
    }
    
    func checkToastNoPhoto() {
        print("Check that toast is displayed and label is right")
        XCTAssertTrue(toast.waitForExistence(timeout: 1), "Toast did not appear")
        XCTAssertEqual(toast.label, "Error: No photo available for download", "Label on the toast should dispaly 'Error: No photo available for download'")
    }
    
    func checkAlert() {
        print("Check that alert is displayed and label is right")
        XCTAssertTrue(alert.waitForExistence(timeout: 3), "Alert did not appear")
        XCTAssertEqual(alert.label, "Something went wrong", "The alert label should display 'Something went wrong'")
    }
    
    func checkThatScreenIsOpened() {
        print("Check that Dogs VC is opened")
        XCTAssertTrue(dogsVC.waitForExistence(timeout: 3), "Dogs VC did not appear")
    }
    
    func checkDogButton() {
        print("Check that new cat button exists and label is right")
        XCTAssertTrue(buttonDog.waitForExistence(timeout: 3), "Button did not appear")
        XCTAssertEqual(buttonDog.label, "New Dog", "The name of the button 'New Dog' is incorrect")
    }
    
    func checkSaveButton() {
        print("Check that save button exists and label is right")
        XCTAssertTrue(buttonSaveImage.waitForExistence(timeout: 3), "Save button did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "The name of the button 'Save Photo' is incorrect")
    }
    
    func checkLabel() {
        let dogsViewLabel = app.staticTexts["RandomDogLabelIdentifier"]
        print("Check that cats view label exists and displays 'Random Dog Photo'")
        XCTAssertTrue(dogsViewLabel.waitForExistence(timeout: 3), "Cats view label did not appear")
        XCTAssertEqual(dogsViewLabel.label, "Random Dog Photo", "The title label should display 'Random Dog Photo'.")
    }
    
    func checkThatTabBarExists() {
        XCTAssertTrue(tabBar.waitForExistence(timeout: 3), "Tab bar does not exist")
    }
}
