//
//  ViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 25.08.24.
//

import UIKit
import Photos

class ViewController: UIViewController {
    var session: URLSession = URLSession.shared
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Random Photo"
        label.textColor = .systemMint
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "RandomPhotoLabelIdentifier"
        
        // Adding shadow to the text for better visibility
        label.layer.shadowColor = UIColor.black.cgColor // Shadow color
        label.layer.shadowOffset = CGSize(width: 2, height: 2) // Shadow offset
        label.layer.shadowOpacity = 0.7 // Shadow opacity
        label.layer.shadowRadius = 2.0 // Shadow blur radius
        return label
    }()
    
    // ImageView for photo
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
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
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.accessibilityIdentifier = "InfoButtonIdentifier"
        return infoButton
    }()
    
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = .systemMint
        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.accessibilityIdentifier = "SaveButtonIdentifier"
        return saveButton
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
        view.accessibilityIdentifier = "MainVCIdentifier"
        colors.shuffle()
        view.backgroundColor = colors.randomElement()
        imageView.backgroundColor = view.backgroundColor
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 380, height: 350)
        imageView.center = view.center
        getRandomPhoto()
    
        view.addSubview(label)
        // Setting constraints to position the label in the top-left corner
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(button)
        button.frame = CGRect(x: 55, y: view.frame.size.height - 210, width: view.frame.size.width - 110, height: 40)
        button.addTarget(self, action: #selector(didTapButtonPhoto), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.frame = CGRect(x: 55, y: view.frame.size.height - 150, width: view.frame.size.width - 110, height: 40)
        saveButton.addTarget(self, action: #selector(didTapButtonSavePhoto), for: .touchUpInside)
        
        view.addSubview(infoButton) // Add the info button to the view
        // Set constraints to position the button in the top-right corner
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        infoButton.addTarget(self, action: #selector(showInfoBottomSheet), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader(in: imageView)
    }
    
    // Function to handle the tap on button and change the background color
    @objc func didTapButtonPhoto() {
        // Check if currentColorIndex reaches the end, then reset
        if currentColorIndex >= colors.count {
            colors.shuffle() //
            currentColorIndex = 0 
        }
        getRandomPhoto()
        view.backgroundColor = colors[currentColorIndex] // Change background color
        currentColorIndex += 1 // Move to the next color
    }
    
    // Asynch function for fetching new photo
    func getRandomPhoto() {
        let urlString = "https://picsum.photos/1024"
        startLoader()
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Using URLSession to fetch the data asynchronously
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    stopLoader()
                    self.showErrorAlert(message: "\(error)")
                }
                return
            }
            
            // Check if the response status code is not 200
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server returned status code: \(httpResponse.statusCode)")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    stopLoader()
                    self.showErrorAlert(message: "HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }
            guard let data = data else {
                print("No data returned from the request")
                // Show an alert on the main thread
                DispatchQueue.main.async {
                    stopLoader()
                    self.showErrorAlert(message: "No data received.")
                }
                return
            }
            // Updating the UI on the main thread
            DispatchQueue.main.async {
                stopLoader()
                self.imageView.image = UIImage(data: data)
                self.imageView.accessibilityLabel = "ImageLoaded"
            }
        }.resume() // Starting the task
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        alertController.view.accessibilityIdentifier = "ErrorAlertIdentifier"
        
        // Find the first active UIWindowScene and its window
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let currentViewController = window.rootViewController {
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func showInfoBottomSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "InfoBottomSheetVC")  // Instantiate the view controller from storyboard by storyboardID
        
        bottomSheetVC.view.accessibilityIdentifier = "BottomSheetIdentifier"  // Add accessibility identifier to the view of the bottom sheet
        
        let bottomLabel = UILabel()
        bottomLabel.text = "I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners."
        bottomLabel.textColor = .black
        bottomLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        bottomLabel.textAlignment = .center
        bottomLabel.numberOfLines = 0
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.accessibilityIdentifier = "BottomLabelIdentifier"
          
        // Adding the label to the bottomSheetVC's view
        bottomSheetVC.view.addSubview(bottomLabel)
          
        // Setting up Auto Layout constraints to center the label
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: bottomSheetVC.view.centerXAnchor),
            bottomLabel.centerYAnchor.constraint(equalTo: bottomSheetVC.view.centerYAnchor),
            bottomLabel.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 20), // Added some padding
            bottomLabel.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -20) // Added some padding
        ])
        
        if let sheetPresentation = bottomSheetVC.sheetPresentationController { // Configuring the bottom sheet
            sheetPresentation.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.3 // Set to 30% of the screen height
                }
            ]
            present(bottomSheetVC, animated: true, completion: nil) // Present the bottom sheet
        }
    }
    
    func saveImageToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            DispatchQueue.main.async {
                self.showToast(message: "Something went wrong, image not saved")
            }
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            DispatchQueue.main.async {
                self.showToast(message: "Image saved succesfully", duration: 1)
            }
            print("Image saved successfully!")
        }
    }
    
    func checkPhotoLibraryPermission(image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            // Access granted, proceed with saving
            saveImageToLibrary(image: image)
            break
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.showToast(message: "Error: Please allow access to the photo library in settings.") // Access denied, show a toast explaining the need for permission
            }
            break
        case .notDetermined:
            // Request permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        // Access granted, proceed with saving
                        self.saveImageToLibrary(image: image)
                    } else {
                        // Access denied, show a message to the user
                        self.showToast(message: "Error. Please allow access to the photo library in settings.")
                    }
                }
            }
        @unknown default:
            DispatchQueue.main.async {
                self.showToast(message: "Error: Please allow access to the photo library in settings.")
            }
        }
    }
    
    @objc func didTapButtonSavePhoto() {
        if let image = imageView.image {
            // If there's an image in the imageView, check permission and save
            checkPhotoLibraryPermission(image: image)
        } else {
            // Show a toast message if no image is available for download
            DispatchQueue.main.async {
                self.showToast(message: "Error: No photo available for download")
            }
        }
    }
    
    func showToast(message: String, duration: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "ToastIdentifier"
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
