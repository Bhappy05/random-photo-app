//
//  DogsViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 04.09.24.
//

import UIKit

class DogsViewController: UIViewController {
    var session: URLSession = URLSession.shared
    
    // ImageView for photo
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.accessibilityIdentifier = "DogsImageViewIdentifier"
        return imageView
    }()
    
    // Button for new photo
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("New Random Dog", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "RandomDogButtonIdentifier"
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        getRandomDog()
        
        view.addSubview(button)
        button.frame = CGRect(x: 30, y: view.frame.size.height - 250, width: view.frame.size.width - 60, height: 50)
        button.addTarget(self, action: #selector(didTapButtonDog), for: .touchUpInside)
    }
    
    // Function to handle the tap on button
    @objc func didTapButtonDog() {
        getRandomDog()
    }
    
    // Asynch function for fetching new dog photo
    func getRandomDog() {
        // In this case i have made randomizer for different Id's of dogs
        let randomId = Int.random(in: 1...238)
        let urlString = "https://placedog.net/300/300?id=\(randomId)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Using URLSession to fetch the data asynchronously
        session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching image: \(String(describing: error))")
                    return
                }
            // Updating the UI on the main thread
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume() // Starting the task
    }
}
