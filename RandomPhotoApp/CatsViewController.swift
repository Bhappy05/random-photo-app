//
//  CatsViewController.swift
//  RandomPhotoApp
//
//  Created by Dionis on 04.09.24.
//

import UIKit
import Photos

class CatsViewController: UIViewController {
    var session: URLSession = .shared
    private let buttonGradientLayer = CAGradientLayer()
    private let saveButtonGradientLayer = CAGradientLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Random Cat Photo"
        label.textColor = .systemMint
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "RandomCatLabelIdentifier"
        
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
        imageView.backgroundColor = .systemMint
        imageView.accessibilityIdentifier = "CatsImageViewIdentifier"
        
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
        button.backgroundColor = .systemPink
        button.setTitle("New Cat", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "RandomCatButtonIdentifier"
        
        // Rounding corners
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
          
        // Dimming when pressed
        button.configureWithTouchEffects()
        
        return button
    }()
    
    // Button to save photo to the library
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = .systemMint
        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Georgia", size: 20)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.accessibilityIdentifier = "SaveButtonIdentifier"
        
        // Rounding corners
        saveButton.layer.cornerRadius = 15
        saveButton.clipsToBounds = true
          
        // Dimming when pressed
        saveButton.configureWithTouchEffects()
        
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "CatsVCIdentifier"
        view.backgroundColor = .systemMint
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 370, height: 430)
        imageView.center.x = view.center.x
        imageView.center.y = view.center.y - 50
        getRandomCat()
        
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
        
        // Gradient color for 'New Cat' button
        buttonGradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemYellow.cgColor
        ]
        buttonGradientLayer.startPoint = CGPoint(x: 0.1, y: 0.0)
        buttonGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        button.layer.insertSublayer(buttonGradientLayer, at: 0)
        
        button.addTarget(self, action: #selector(didTapButtonCat), for: .touchUpInside) //
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader(in: imageView) // Setup the loader whenever the view appears
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonGradientLayer.frame = button.bounds
        saveButtonGradientLayer.frame = saveButton.bounds
    }
    
    // Function to handle the tap on button
    @objc func didTapButtonCat() {
        getRandomCat()
    }
    
    // Asynch function for fetching new cat photo
    func getRandomCat() {
        let urlString = "https://cataas.com/cat?width=1024&height=1024"
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
