//
//  SceneDelegate.swift
//  RandomPhotoApp
//
//  Created by Dionis on 25.08.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Handling deeplink when the app is already running
        guard let url = URLContexts.first?.url else { return }
        handleDeeplink(url: url)
    }
    
    func scene(_ scene: UIScene,  willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window?.rootViewController = nil  // Deleting old rootViewController
        window = nil  // Free the memory for `UIWindow`
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        // Check if the app is running in a test environment for error
        if ProcessInfo.processInfo.environment["UITestModeError"] == "true" {
            setupMockSession(isSuccess: false)
        }
        
        // Check if the app is running in a test environment for success
        if ProcessInfo.processInfo.environment["UITestModeSuccess"] == "true" {
            setupMockSession(isSuccess: true)
        }
        
        // Handling deeplink if the app is being launched via a URL
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeeplink(url: url)
        }
        
        // Handling deeplink if the app is being launched via UI tests with launch arguments
        if CommandLine.arguments.contains("-deeplink") {
            if let index = CommandLine.arguments.firstIndex(of: "-deeplink"), CommandLine.arguments.count > index + 1 {
                let deepLinkURLString = CommandLine.arguments[index + 1]
                if let url = URL(string: deepLinkURLString) {
                    handleDeeplink(url: url)
                }
            }
        }
    }
    
    // Function to handle all app deeplinks
    private func handleDeeplink(url: URL) {
        if url.scheme == "randomphotoapp" {
            // Check if rootViewController is UITabBarController
            if let tabBarController = window?.rootViewController as? UITabBarController {
                // If its one of other screens then go to the MainVC
                if !(tabBarController.selectedViewController is ViewController) {
                    tabBarController.selectedIndex = 0 // index of the MainViewController
                }
            }
        }
        
        if url.scheme == "randomphotoappcats" {
            // Check if rootViewController is UITabBarController
            if let tabBarController = window?.rootViewController as? UITabBarController {
                // If its one of other screens then go to the CatsVC
                if !(tabBarController.selectedViewController is CatsViewController) {
                    tabBarController.selectedIndex = 1 // index of the CatsViewController
                }
            }
        }
        
        if url.scheme == "randomphotoappdogs" {
            // Check if rootViewController is UITabBarController
            if let tabBarController = window?.rootViewController as? UITabBarController {
                // If its one of other screens then go to the DogsVC
                if !(tabBarController.selectedViewController is DogsViewController) {
                    tabBarController.selectedIndex = 2 // index of the DogsViewController
                }
            }
        }
    }
    
    private func setupMockSession(isSuccess: Bool) {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        if isSuccess {
            let mockImage = UIImage(systemName: "star")!
            MockURLProtocol.responseData = mockImage.pngData()
            MockURLProtocol.statusCode = 200
        } else {
            MockURLProtocol.responseData = Data()
            MockURLProtocol.statusCode = 404
        }
        
        if let tabBarController = window?.rootViewController as? UITabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                if let MainVC = viewController as? ViewController {
                    MainVC.session.invalidateAndCancel()
                    MainVC.session = session
                } else if let CatsVC = viewController as? CatsViewController {
                    CatsVC.session.invalidateAndCancel()
                    CatsVC.session = session
                } else if let DogsVC = viewController as? DogsViewController {
                    DogsVC.session.invalidateAndCancel()
                    DogsVC.session = session
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

