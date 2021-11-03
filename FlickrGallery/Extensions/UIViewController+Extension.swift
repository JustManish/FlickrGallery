//
//  UIViewController+Extension.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAlert(title: String = "Flickr", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
