//
//  PhotoModel.swift
//  Flickr
//
//  Created by Ajay Kunte on 10/04/25.
//

import Foundation

struct PexelsPhoto: Decodable {
    let id: Int
    let src: PhotoSource

    struct PhotoSource: Decodable {
        let medium: String
    }

    var imageURL: String {
        return src.medium
    }
}

struct PexelsResponse: Decodable {
    let photos: [PexelsPhoto]
}
