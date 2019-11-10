//
//  ImageCacheHelper.swift
//  Celo Tech Interview
//
//  Cache images to improve performance
//
//  Created by Ellen Zhang on 9/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheHelper{
    
    static let cache = NSCache<NSString, UIImage>()
    
    /// Download image from URL
    /// - Parameters:
    ///   - url: images URL
    ///   - completion:
    static func downloadImage(withURL url:URL, completion:@escaping (_ image:UIImage?) -> ()){
        let dataTask = URLSession.shared.dataTask(with: url){
            data, responseURL, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                completion(downloadedImage)
            }

        }
        dataTask.resume()
    }
    
    /// Get image from URL or Cache
    /// - Parameters:
    ///   - url: image URL
    ///   - completion:
    static func getImage(withURL url:URL, completion:@escaping (_ image:UIImage?) -> ()){
        if let image = cache.object(forKey: url.absoluteString as NSString){
            completion(image)
        }else{
            downloadImage(withURL: url, completion: completion)
        }
    }
}
