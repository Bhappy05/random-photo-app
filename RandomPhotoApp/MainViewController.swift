//
//  ViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 25.08.24.
//

import UIKit
import Photos

class ViewController: UIViewController {
    var session: URLSession = .shared
    private let buttonGradientLayer = CAGradientLayer()
    private let saveButtonGradientLayer = CAGradientLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Random Photo"
        label.textColor = .systemMint
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "RandomPhotoLabelIdentifier"
        
        // Adding shadow to the text for better visibility
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowOpacity = 0.7
        label.layer.shadowRadius = 2.0
        return label
    }()
    
    // ImageView for photo
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.accessibilityIdentifier = "MainImageViewIdentifier"
        
        // Borders for imageView
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.systemMint.cgColor
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // Button for new photo
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("New Photo", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "RandomPhotoButtonIdentifier"
        button.backgroundColor = .systemMint
        
        // Rounding corners
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        
        // Dimming when pressed
        button.configureWithTouchEffects()
        
        return button
    }()
    
    // Button for oppening bottomSheet with info
    private let infoButton: UIButton = {
        let infoButton = UIButton(type: .infoDark)
        infoButton.tintColor = .white
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.accessibilityIdentifier = "InfoButtonIdentifier"
        return infoButton
    }()
    
    // Button to save photo to the library
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Georgia", size: 20)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.accessibilityIdentifier = "SaveButtonIdentifier"
        saveButton.backgroundColor = .systemMint
        
        // Rounding corners
        saveButton.layer.cornerRadius = 15
        saveButton.clipsToBounds = true
          
        // Dimming when pressed
        saveButton.configureWithTouchEffects()
        
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
        colors.shuffle() // Mixing colors for background
        view.backgroundColor = colors.randomElement()
        imageView.backgroundColor = view.backgroundColor
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 370, height: 430)
        imageView.center.x = view.center.x
        imageView.center.y = view.center.y - 50
        
        if ProcessInfo.processInfo.environment["UITestModeError"] != "true" { // Special condition for test environment to not download the photo if testing errors
            getRandomPhoto()
        }
        
        view.addSubview(label)
        // Setting constraints to position the label in the top-left corner
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 170),
            button.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Gradient color for 'New photo' button
        buttonGradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemYellow.cgColor
        ]
        buttonGradientLayer.startPoint = CGPoint(x: 0.1, y: 0.0)
        buttonGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        button.layer.insertSublayer(buttonGradientLayer, at: 0)
        
        button.addTarget(self, action: #selector(didTapButtonPhoto), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            saveButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 170),
            saveButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Gradient color for save button
        saveButtonGradientLayer.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.systemTeal.cgColor,
            UIColor.systemMint.cgColor
        ]
        saveButtonGradientLayer.startPoint = CGPoint(x: 0.1, y: 0.0)
        saveButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        saveButton.layer.insertSublayer(saveButtonGradientLayer, at: 0)
        
        saveButton.addTarget(self, action: #selector(didTapButtonSavePhoto), for: .touchUpInside)
        
        view.addSubview(infoButton)
        // Setting constraints to position the button in the top-right corner
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        infoButton.addTarget(self, action: #selector(showInfoBottomSheet), for: .touchUpInside)
        
        // Settings for UITabBar
        let appearance = UITabBarItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Georgia", size: 14)!
        ]
        appearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader(in: imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonGradientLayer.frame = button.bounds
        saveButtonGradientLayer.frame = saveButton.bounds
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
                // Show an alert on the main thread if error
                DispatchQueue.main.async {
                    stopLoader()
                    self.showErrorAlert(message: "\(error)")
                }
                return
            }
            
            // Check if the response status code is not 200
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server returned status code: \(httpResponse.statusCode)")
                // Show an alert on the main thread if response code is not 200
                DispatchQueue.main.async {
                    stopLoader()
                    self.showErrorAlert(message: "HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }
            guard let data = data else {
                print("No data returned from the request")
                // Show an alert on the main thread if there is no photo
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
        
        // Finding the first active UIWindowScene and its window to present alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let currentViewController = window.rootViewController {
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func showInfoBottomSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "InfoBottomSheetVC")  // Instantiates the view controller from storyboard by storyboardID
        
        bottomSheetVC.view.accessibilityIdentifier = "BottomSheetIdentifier"
        
        let bottomLabel = UILabel()
        bottomLabel.text = "I do not own the rights for any of these images. They are all taken from open sources. All credits go to the rightful owners."
        bottomLabel.textColor = .black
        bottomLabel.font = UIFont(name: "Georgia", size: 22)
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
                    return context.maximumDetentValue * 0.3 // Sets to 30% of the screen height
                }
            ]
            present(bottomSheetVC, animated: true, completion: nil) // Presents the bottom sheet
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
                self.showToast(message: "Image saved succesfully", duration: 1.5)
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
        alert.view.accessibilityLabel = message
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIButton {
    func configureWithTouchEffects() {
        self.addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func handleTouchDown() {
        self.alpha = 0.7 // Dimming when pressing the button
    }
    
    @objc private func handleTouchUp() {
        self.alpha = 1.0 // Recovering when releasing the button
    }
}
