//
//  ImageCacheManager.swift
//  Flickr
//
//  Created by Ajay Kunte on 10/04/25.
//

import UIKit

// Image Cache Manager
class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
}
