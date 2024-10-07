//
//  CatsViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 04.09.24.
//

import UIKit

class CatsViewController: UIViewController {
    var session: URLSession = URLSession.shared
    
    // ImageView for photo
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.accessibilityIdentifier = "CatsImageViewIdentifier"
        return imageView
    }()
    
    // Button for new photo
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("New Random Cat", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "RandomCatButtonIdentifier"
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "CatsVCIdentifier"
        view.backgroundColor = .systemMint
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        getRandomCat()
        
        view.addSubview(button)
        button.frame = CGRect(x: 30, y: view.frame.size.height - 250, width: view.frame.size.width - 60, height: 50)
        button.addTarget(self, action: #selector(didTapButtonCat), for: .touchUpInside)
    }
    
    // Function to handle the tap on button
    @objc func didTapButtonCat() {
        getRandomCat()
    }
    
    // Asynch function for fetching new cat photo
    func getRandomCat() {
        let urlString = "https://cataas.com/cat?width=300&height=300"
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Using URLSession to fetch the data asynchronously
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "\(error)")
                }
                return
            }
            
            // Check if the response status code is not 200
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server returned status code: \(httpResponse.statusCode)")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }
            guard let data = data else {
                print("No data returned from the request")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "No data received.")
                }
                return
            }
            // Updating the UI on the main thread
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume() // Starting the task
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Find the first active UIWindowScene and its window
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let currentViewController = window.rootViewController {
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
