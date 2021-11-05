//
//  UIImageView+Extension.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import UIKit


extension UIImageView {
    
    func downloadImage(_ url: String) {
        let serialQueue = DispatchQueue(label: "flickrgallery.serial.queue")
        serialQueue.async {
            NetworkService.shared.downloadImageFrom(url) { (result) in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        
                        self.image = image
                    default:
                        break
                    }
                }
            }
        }
    }
}
