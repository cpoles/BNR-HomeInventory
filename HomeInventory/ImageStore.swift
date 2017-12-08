//
//  ImageStore.swift
//  HomeInventory
//
//  Created by Carlos Poles on 6/12/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class ImageStore {
    
    // MARK: - Properties
    let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Class Methods
    // A function that adds an image to the cache
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = UIImagePNGRepresentation(image) {
            // Write it to full URL
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    // A function that returns an image based on its key
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
        
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
