//
//  IndexedImageStore.swift
//  Clapperboard
//
//  Created by Steve Johnson on 03/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class IndexedImageStore: NSObject {
    
    // MARK: - Public Properties
    
    typealias GetImageCompletion = (_ image: UIImage, _ indexPath: IndexPath)->(Void)
    
    var blankImage: UIImage?
    
    
    // MARK: - Private Properties
    
    private var urlSession: URLSession?
    private var images: [IndexPath:UIImage] = [:]
    
    
    // MARK: - Lifecycle
    
    required init(blankImage: UIImage?, diskPathToCache diskPath: String) {
        self.blankImage = blankImage
        self.urlSession = IndexedImageStore.urlSession(diskPathToCache: diskPath)
        super.init()
    }
    
    static func urlSession(diskPathToCache diskPath: String) -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        if diskPath.characters.count > 0 {
            let cacheSizeMemory = 50 * 1024 * 1024 // 50Mb
            let cacheSizeDisk = 200 * 1024 * 1024 // 200Mb
            let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: diskPath)
            config.urlCache = cache
        }
        return URLSession(configuration: config)
    }
    
    func store(image: UIImage, atIndexPath indexPath:IndexPath, completion: @escaping GetImageCompletion) {
        images[indexPath] = image
        DispatchQueue.main.async {
            completion(image, indexPath)
        }
    }
 
    func loadImage(urlString: String, forIndexPath indexPath: IndexPath, completion: @escaping GetImageCompletion) {
        if (urlString.characters.count == 0) { return }
        if let url = URL(string: urlString) {
            loadImage(url: url, forIndexPath: indexPath, completion: completion)
        }
    }
    
    func loadImage(url: URL, forIndexPath indexPath: IndexPath, completion: @escaping GetImageCompletion) {
        urlSession?.dataTask(with: url) { (data, response, error) in
            
            if (error != nil) {
                print("\(error?.localizedDescription)")
                return
            }
            
            if (data == nil) {
                print("No data returned.")
            }
            
            if let image = UIImage(data: data!) {
                self.store(image: image, atIndexPath: indexPath, completion: completion)
            }
        }.resume()
    }
    
    func image(atIndexPath indexPath: IndexPath) -> UIImage? {
        if let image = images[indexPath] { return image }
        return blankImage
    }
    
    func isImageStored(atIndexPath indexPath: IndexPath) -> Bool {
        return images[indexPath] != nil
    }
}
