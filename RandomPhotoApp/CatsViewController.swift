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
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Random Cat Photo"
        label.textColor = .systemMint
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "RandomCatLabelIdentifier"
        
        // Adding shadow to the text for better visibility
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
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
    
    // Button to save photo to the library
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = .systemMint
        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.accessibilityIdentifier = "SaveButtonIdentifier"
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "CatsVCIdentifier"
        view.backgroundColor = .systemMint
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 380, height: 350)
        imageView.center = view.center
        getRandomCat()
        
        view.addSubview(label)
        // Setting constraints to position the label in the top-left corner
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(button)
        button.frame = CGRect(x: 55, y: view.frame.size.height - 210, width: view.frame.size.width - 110, height: 40)
        button.addTarget(self, action: #selector(didTapButtonCat), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.frame = CGRect(x: 55, y: view.frame.size.height - 150, width: view.frame.size.width - 110, height: 40)
        saveButton.addTarget(self, action: #selector(didTapButtonSavePhoto), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoader(in: imageView) // Start the loader whenever the view appears
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
