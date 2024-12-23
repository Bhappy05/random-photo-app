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
        guard let url = URLContexts.first?.url else {
            return
        }
        
        if url.scheme == "randomphotoapp" {
            // Check if rootViewController is UITabBarController
            if let tabBarController = window?.rootViewController as? UITabBarController {
                // If its one of other screens then go to the MainVC
                if !(tabBarController.selectedViewController is ViewController) {
                    tabBarController.selectedIndex = 0 // index of the MainViewController
                }
            }
        }
    }
    
    func scene(_ scene: UIScene,  willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        // Check if the app is running in a test environment
        if ProcessInfo.processInfo.environment["UITestMode"] == "true" {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            let session = URLSession(configuration: configuration)
            
            // Assigning the session to all controllers
            if let tabBarController = window?.rootViewController as? UITabBarController {
                for viewController in tabBarController.viewControllers ?? [] {
                    if let MainVC = viewController as? ViewController {
                        MainVC.session = session
                    } else if let CatsVC = viewController as? CatsViewController {
                        CatsVC.session = session
                    } else if let DogsVC = viewController as? DogsViewController {
                        DogsVC.session = session
                    }
                }
                MockURLProtocol.responseData = Data()
                MockURLProtocol.statusCode = 404
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

