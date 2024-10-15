//
//  RandomPhotoAppTests.swift
//  RandomPhotoAppTests
//
//  Created by Dionis on 25.08.24.
//

import XCTest
@testable import RandomPhotoApp
    
final class RandomPhotoAppUnitTests: XCTestCase {
    
    override func setUpWithError() throws {
        MockURLProtocol.responseData = nil // Reset mock data
    }
    
    override func tearDownWithError() throws { // Clean up resources and reset states
        MockURLProtocol.responseData = nil // Reset mock data
    }
    
    func testLaunchScreen() {
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let viewController = launchScreen.instantiateInitialViewController()!
        
        let label = viewController.view.subviews.compactMap({ $0 as? UILabel }).first!
        XCTAssertEqual(label.text, "Random Photo App \nby Denis Kovalev")
        
        let imageView = viewController.view.subviews.compactMap({ $0 as? UIImageView }).first!
        XCTAssertNotNil(imageView.image)
    }
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test for image fetching
    func testGetRandomPhoto_Success() async throws {	
        let viewController = ViewController()
        let urlString = "https://picsum.photos/300"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        
        // Fetch image asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Ensure valid response and data
        XCTAssertNotNil(data, "Data should not be nil")
        XCTAssertNotNil(response, "Response should not be nil")
        
        // Verify image creation from fetched data
        let downloadedImage = UIImage(data: data)
        XCTAssertNotNil(downloadedImage, "Downloaded image should not be nil")
        
        // Assign image to imageView in the view controller
        DispatchQueue.main.async {
            viewController.imageView.image = downloadedImage
            XCTAssertNotNil(viewController.imageView.image, "ImageView should have an image")
        }
    }
    
    func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        // Use MockURLProtocol for handling all network requests
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test to simulate button tap and verify image changes
    func testButtonTapChangesPhoto() async throws {
        let viewController = ViewController()
        
        // Set the initial image
        let initialImage = UIImage(systemName: "photo")!
        viewController.imageView.image = initialImage
        
        // Set mock data for the new image
        let newImage = UIImage(systemName: "star")!
        MockURLProtocol.responseData = newImage.pngData()
        
        // Use the custom session to simulate the image fetch
        let session = makeMockSession()
        viewController.session = session
        viewController.didTapButtonPhoto() // Tap button with simulating image load
        
        // Wait for the image download to complete
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Ensure the image has changed
        XCTAssertNotEqual(viewController.imageView.image, initialImage, "Image should change after button tap")
    }
    
    //
    // Unit tests for CatsViewController
    //
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test for image fetching
    func testGetRandomCat_Success() async throws {
        let viewController = CatsViewController()
        let urlString = "https://cataas.com/cat?width=300&height=300"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        
        // Fetch image asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Ensure valid response and data
        XCTAssertNotNil(data, "Data should not be nil")
        XCTAssertNotNil(response, "Response should not be nil")
        
        // Verify image creation from fetched data
        let downloadedImage = UIImage(data: data)
        XCTAssertNotNil(downloadedImage, "Downloaded image should not be nil")
        
        // Assign image to imageView in the view controller
        DispatchQueue.main.async {
            viewController.imageView.image = downloadedImage
            XCTAssertNotNil(viewController.imageView.image, "ImageView should have an image")
        }
    }
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test to simulate button tap and verify image changes
    func testButtonTapChangesCat() async throws {
        let viewController = CatsViewController()
        
        // Set the initial image
        let initialImage = UIImage(systemName: "photo")!
        viewController.imageView.image = initialImage
        
        // Set mock data for the new image
        let newImage = UIImage(systemName: "star")!
        MockURLProtocol.responseData = newImage.pngData()
        
        // Use the custom session to simulate the image fetch
        let session = makeMockSession()
        viewController.session = session
        viewController.didTapButtonCat() // Tap button with simulating image load
        
        // Wait for the image download to complete
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Ensure the image has changed
        XCTAssertNotEqual(viewController.imageView.image, initialImage, "Image should change after button tap")
    }
    
    //
    // Unit tests for DogsViewController
    //
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test for image fetching
    func testGetRandomDog_Success() async throws {
        let viewController = DogsViewController()
        let urlString = "https://placedog.net/300/300?id=5"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        
        // Fetch image asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Ensure valid response and data
        XCTAssertNotNil(data, "Data should not be nil")
        XCTAssertNotNil(response, "Response should not be nil")
        
        // Verify image creation from fetched data
        let downloadedImage = UIImage(data: data)
        XCTAssertNotNil(downloadedImage, "Downloaded image should not be nil")
        
        // Assign image to imageView in the view controller
        DispatchQueue.main.async {
            viewController.imageView.image = downloadedImage
            XCTAssertNotNil(viewController.imageView.image, "ImageView should have an image")
        }
    }
    
    @MainActor // This allows us to remove the await keyword before the ImageViewController constructor since the unit test will now run in a Main actor-isolated context.
    // Asynchronous test to simulate button tap and verify image changes
    func testButtonTapChangesDog() async throws {
        let viewController = DogsViewController()
        
        // Set the initial image
        let initialImage = UIImage(systemName: "photo")!
        viewController.imageView.image = initialImage
        
        // Set mock data for the new image
        let newImage = UIImage(systemName: "star")!
        MockURLProtocol.responseData = newImage.pngData()
        
        // Use the custom session to simulate the image fetch
        let session = makeMockSession()
        viewController.session = session
        viewController.didTapButtonDog()  // Tap button with simulating image load
        
        // Wait for the image download to complete
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Ensure the image has changed
        XCTAssertNotEqual(viewController.imageView.image, initialImage, "Image should change after button tap")
    }
}
