//
//  CatsPage.swift
//  RandomPhotoApp
//
//  Created by Dionis on 23.02.25.
//

import XCTest

final class CatsPageObject: XCTestCase {
    let app: XCUIApplication = XCUIApplication()
    
    // Mark: - Elements
    
    lazy var catsVC: XCUIElement = {
        return app.otherElements["CatsVCIdentifier"]
    }()
    
    lazy var catsImageView: XCUIElement = {
        return app.images["CatsImageViewIdentifier"]
    }()
    
    lazy var loader: XCUIElement = {
        return app.activityIndicators["ImageLoaderIdentifier"]
    }()
    
    lazy var buttonCat: XCUIElement = {
        return app.buttons["RandomCatButtonIdentifier"]
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
    
    lazy var dogsTab: XCUIElement = {
        return tabBar.buttons["Dogs"]
    }()
    
    // Mark: - Actions
    func tapLoadButton() {
        print("Tap 'New Cat' button")
        buttonCat.tap()
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
        print("Tap Dogs tab")
        dogsTab.tap()
    }
    
    // Mark: - Asserts
    
    func checkImageView() {
        print("Check that image view exists")
        XCTAssertTrue(catsImageView.waitForExistence(timeout: 3), "Cats image view does not exists")
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
        print("Check that Cats VC is opened")
        XCTAssertTrue(catsVC.waitForExistence(timeout: 3), "Cats VC did not appear")
    }
    
    func checkCatButton() {
        print("Check that new cat button exists and label is right")
        XCTAssertTrue(buttonCat.waitForExistence(timeout: 3), "Button did not appear")
        XCTAssertEqual(buttonCat.label, "New Cat", "The name of the button 'New Cat' is incorrect")
    }
    
    func checkSaveButton() {
        print("Check that save button exists and label is right")
        XCTAssertTrue(buttonSaveImage.waitForExistence(timeout: 3), "Save button did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "The name of the button 'Save Photo' is incorrect")
    }
    
    func checkLabel() {
        let catsViewLabel = app.staticTexts["RandomCatLabelIdentifier"]
        print("Check that cats view label exists and displays 'Random Cat Photo'")
        XCTAssertTrue(catsViewLabel.waitForExistence(timeout: 3), "Cats view label did not appear")
        XCTAssertEqual(catsViewLabel.label, "Random Cat Photo", "The title label should display 'Random Cat Photo'.")
    }
    
    func checkThatTabBarExists() {
        XCTAssertTrue(tabBar.waitForExistence(timeout: 3), "Tab bar does not exist")
    }
}

