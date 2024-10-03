//
//  ViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 25.08.24.
//

import UIKit

class ViewController: UIViewController {
    var session: URLSession = URLSession.shared
    
    // ImageView for photo
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.accessibilityIdentifier = "MainImageViewIdentifier"
        return imageView
    }()
    
    // Button for new photo
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("New Random Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "RandomPhotoButtonIdentifier"
        return button
    }()
    
    private let infoButton: UIButton = {
        let infoButton = UIButton(type: .infoDark)
        infoButton.tintColor = .white
        infoButton.accessibilityIdentifier = "InfoButtonIdentifier"
        return infoButton
    }()
    
    // Array of colors for background
    private var colors: [UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemPurple,
        .systemOrange,
        .systemRed,
        .systemIndigo,
        .systemTeal
    ]
    
    private var currentColorIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors.shuffle()
        view.backgroundColor = colors.randomElement()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        getRandomPhoto()
        
        view.addSubview(button)
        button.frame = CGRect(x: 30, y: view.frame.size.height - 250, width: view.frame.size.width - 60, height: 50)
        button.addTarget(self, action: #selector(didTapButtonPhoto), for: .touchUpInside)
        
        view.addSubview(infoButton) // Add the info button to the view
        infoButton.translatesAutoresizingMaskIntoConstraints = false // Disable auto-resizing mask
        // Set constraints to position the button in the top-right corner
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        infoButton.addTarget(self, action: #selector(showInfoBottomSheet), for: .touchUpInside)
    }
    
    // Function to handle the tap on button and change the background color
    @objc func didTapButtonPhoto() {
        // Check if currentColorIndex reaches the end, then reset
        if currentColorIndex >= colors.count {
            colors.shuffle() //
            currentColorIndex = 0 
        }
        view.backgroundColor = colors[currentColorIndex] // Change background color
        currentColorIndex += 1 // Move to the next color
        getRandomPhoto()
    }
    
    // Asynch function for fetching new photo
    func getRandomPhoto() {
        let urlString = "https://picsum.photos/300"
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
    
    @objc private func showInfoBottomSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "InfoBottomSheetVC")  // Instantiate the view controller from storyboard by storyboardID
        
        bottomSheetVC.view.accessibilityIdentifier = "BottomSheetIdentifier"  // Add accessibility identifier to the view of the bottom sheet
        
        if let sheetPresentation = bottomSheetVC.sheetPresentationController { // Configuring the bottom sheet
            sheetPresentation.detents = [
                    .custom { context in
                        return context.maximumDetentValue * 0.3 // Set to 30% of the screen height
                    }
                ]
            present(bottomSheetVC, animated: true, completion: nil) // Present the bottom sheet
        }
    }


}
