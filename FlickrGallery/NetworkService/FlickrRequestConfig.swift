//
//  FlickrRequestConfig.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import UIKit

enum FlickrRequestConfig {
    
    case searchRequest(String, Int)
    
    var value: HttpRequest? {
        
        switch self {
            
        case .searchRequest(let searchText, let pageNo):
            let urlString = String(format: Constants.searchURL, searchText, pageNo)
            let reqConfig = HttpRequest(httpMethod: .get, urlString: urlString)
            return reqConfig
        }
    }
}
