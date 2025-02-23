//
//  MainPage.swift
//  RandomPhotoApp
//
//  Created by Dionis on 20.02.25.
//

import XCTest

final class MainPageObject: XCTestCase {
    let app: XCUIApplication = XCUIApplication()
    
    // Mark: - Elements
    
    lazy var mainVC: XCUIElement = {
        return app.otherElements["MainVCIdentifier"]
    }()
    
    lazy var mainImageView: XCUIElement = {
        return app.images["MainImageViewIdentifier"]
    }()
    
    lazy var infoButton: XCUIElement = {
        return app.buttons["InfoButtonIdentifier"]
    }()
    
    lazy var loader: XCUIElement = {
        return app.activityIndicators["ImageLoaderIdentifier"]
    }()
    
    lazy var buttonAnyPhoto: XCUIElement = {
        return app.buttons["RandomPhotoButtonIdentifier"]
    }()
    
    lazy var buttonSaveImage: XCUIElement = {
        return app.buttons["SaveButtonIdentifier"]
    }()
    
    lazy var bottomSheet: XCUIElement = {
        return app.otherElements["BottomSheetIdentifier"]
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
    
    lazy var catsTab: XCUIElement = {
        return tabBar.buttons["Cats"]
    }()
    
    lazy var dogsTab: XCUIElement = {
        return tabBar.buttons["Dogs"]
    }()
    
    // Mark: - Actions
    
    func tapInfoButton() {
        print("Tap info button")
        infoButton.tap()
    }
    
    func tapLoadButton() {
        print("Tap 'New Photo' button")
        buttonAnyPhoto.tap()
    }
    
    func tapSaveButton() {
        print("Tap 'Save Photo' button")
        buttonSaveImage.tap()
    }
    
    func closeBottomSheet() {
        print("Swipe down bottom sheet")
        bottomSheet.swipeDown()
    }
    
    func tapCatsTab() {
        print("Tap Cats tab")
        catsTab.tap()
    }
    
    func tapDogsTab() {
        print("Tap Dogs tab")
        dogsTab.tap()
    }
    
    // Mark: - Asserts
    
    func checkInfoButton() {
        print("Check that info button exists")
        XCTAssertTrue(infoButton.exists, "Info button does not exists")
    }
    
    func checkImageView() {
        print("Check that image view exists")
        XCTAssertTrue(mainImageView.waitForExistence(timeout: 3), "Main image view does not exists")
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
        print("Check that toast is displayed and label is right")
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
        print("Check that Main VC is opened")
        XCTAssertTrue(mainVC.waitForExistence(timeout: 3), "Main VC did not appear")
    }
    
    func checkNewPhotoButton() {
        print("Check that new photo button exists and label is right")
        XCTAssertTrue(buttonAnyPhoto.waitForExistence(timeout: 3), "Load button did not appear")
        XCTAssertEqual(buttonAnyPhoto.label, "New Photo", "The name of the button 'New Photo' is incorrect")
    }
    
    func checkSaveButton() {
        print("Check that save button exists and label is right")
        XCTAssertTrue(buttonSaveImage.waitForExistence(timeout: 3), "Save button did not appear")
        XCTAssertEqual(buttonSaveImage.label, "Save Photo", "The name of the button 'Save Photo' is incorrect")
    }
    
    func checkBottomSheet() {
        let infoTextLabel = app.staticTexts["BottomLabelIdentifier"]
        print("Check that bottom sheet is opened and label is right")
        XCTAssertTrue(bottomSheet.waitForExistence(timeout: 2), "Bottom sheet does not exists")
        XCTAssertTrue(infoTextLabel.exists, "The label with identifier 'BottomLabelIdentifier' should exist.")
        XCTAssertEqual(infoTextLabel.label, "I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners.", "Info text is incorrect")
    }
    
    func checkLabel() {
        let mainViewLabel = app.staticTexts["RandomPhotoLabelIdentifier"]
        print("Check that main view label exists and displays 'Random photo'")
        XCTAssertTrue(mainViewLabel.waitForExistence(timeout: 3), "Main view label did not appear")
        XCTAssertEqual(mainViewLabel.label, "Random Photo", "The title label should display 'Random Photo'.")
    }
    
    func checkThatTabBarExists() {
        XCTAssertTrue(tabBar.waitForExistence(timeout: 3), "Tab bar does not exist")
    }
}

