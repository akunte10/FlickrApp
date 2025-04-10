//
//  PhotoCell.swift
//  Flickr
//
//  Created by Ajay Kunte on 10/04/25.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    let imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    // Init the PhotoCell
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        contentView.clipsToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        // Setup constraints for PhotoCell
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // Configure the image and handle cache
    func configure(with photo: PexelsPhoto) {
        let urlString = photo.imageURL
        guard let url = URL(string: urlString) else { return }
        let key = url.absoluteString as NSString

        // Check if image is available in cache
        if let cachedImage = ImageCacheManager.shared.object(forKey: key) {
            imageView.image = cachedImage
            activityIndicator.stopAnimating()
            imageView.alpha = 1
        } else {
            
            // If image is not available in cache fetch the image from url
            imageView.image = nil
            imageView.alpha = 0
            activityIndicator.startAnimating()

            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                ImageCacheManager.shared.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self.imageView.alpha = 1
                    }
                }
            }.resume()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
