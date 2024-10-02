//
//  CatsViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 04.09.24.
//

import UIKit

class CatsViewController: UIViewController {
    
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
        view.backgroundColor = .systemMint
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        
        view.addSubview(button)
        button.frame = CGRect(x: 30, y: view.frame.size.height - 250, width: view.frame.size.width - 60, height: 50)
        
        getRandomCat()
        
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
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensuring there is data and no error
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
