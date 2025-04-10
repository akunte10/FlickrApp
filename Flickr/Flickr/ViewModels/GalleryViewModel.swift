//
//  GalleryViewModel.swift
//  Flickr
//
//  Created by Ajay Kunte on 10/04/25.
//

import Foundation

class GalleryViewModel {
    private(set) var photos: [PexelsPhoto] = []
    private var currentPage = 1
    private var isLoading = false

    var onPhotosUpdated: (() -> Void)?

    // Fetch Images with pagination
    func fetchImages() {
        guard !isLoading else { return }
        isLoading = true
        APIManager.shared.fetchImages(page: currentPage) { [weak self] newPhotos in
            guard let self = self else { return }
            self.photos.append(contentsOf: newPhotos)
            self.currentPage += 1
            self.isLoading = false
            self.onPhotosUpdated?()
        }
    }
}
