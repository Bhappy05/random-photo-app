//
//  ImageLoader.swift
//  RandomPhotoApp
//
//  Created by Dionis on 15.10.24.
//

import Foundation
import UIKit

// Loader for animation while fetching new image
var imageLoader: UIActivityIndicatorView = {
    let imageLoader = UIActivityIndicatorView(style: .large)
    imageLoader.accessibilityIdentifier = "ImageLoaderIdentifier"
    imageLoader.color = .white
    imageLoader.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    imageLoader.translatesAutoresizingMaskIntoConstraints = false
    return imageLoader
}()

func setupLoader(in imageView: UIImageView) {
    // Create a new loader instance
    let loader = UIActivityIndicatorView(style: .large)
    loader.accessibilityIdentifier = "ImageLoaderIdentifier"
    loader.color = .white
    loader.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    loader.translatesAutoresizingMaskIntoConstraints = false
    
    // Adding the loader as a subview of imageView
    imageView.addSubview(imageLoader)
    
    // Center the loader within the imageView
    NSLayoutConstraint.activate([
        imageLoader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        imageLoader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
    ])
}

// Actions to start the loader
func startLoader() {
    imageLoader.startAnimating()
    imageLoader.isHidden = false
}

// Actions to stop the loader
func stopLoader() {
    imageLoader.stopAnimating()
    imageLoader.isHidden = true
}
