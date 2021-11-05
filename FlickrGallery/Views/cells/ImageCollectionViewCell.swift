//
//  ImageCollectionViewCell.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let id = "ImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    var data: FlickrData? {
        didSet {
            if let data = data {
                titleLabel.text = data.title
                imageView.downloadImage(data.imageURL)
            }
        }
    }
}
