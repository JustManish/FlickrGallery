//
//  FlickrData.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import UIKit

struct FlickrData {

    let imageURL: String
    
    let title : String
    
    init(withPhotos photo: Photo) {
        imageURL = photo.imageURL
        title = photo.title
    }
}
